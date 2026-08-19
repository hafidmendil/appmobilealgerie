<?php
/**
 * Mental Health Directory API
 * Unified endpoint for wilayas, professionals, and establishments.
 */

require_once __DIR__ . '/config.php';

$action = $_GET['action'] ?? '';

switch ($action) {
    case 'wilayas':
        getWilayas($pdo);
        break;
    case 'professionals':
        getProfessionals($pdo);
        break;
    case 'establishments':
        getEstablishments($pdo);
        break;
    case 'search':
        searchDirectory($pdo);
        break;
    case 'report':
        submitReport($pdo);
        break;
    default:
        sendResponse(['error' => 'Invalid action'], 400);
}

function getWilayas($pdo) {
    $stmt = $pdo->query("
        SELECT w.*,
        (SELECT COUNT(*) FROM professionals WHERE wilaya_id = w.id) as prof_count,
        (SELECT COUNT(*) FROM establishments WHERE wilaya_id = w.id AND public_private = 'PRIVE') as cabinet_count,
        (SELECT COUNT(*) FROM establishments WHERE wilaya_id = w.id AND public_private = 'PUBLIC') as public_count
        FROM wilayas w
        ORDER BY w.code ASC
    ");
    sendResponse($stmt->fetchAll());
}

function getProfessionals($pdo) {
    $wilayaId = $_GET['wilaya_id'] ?? null;
    $query = "SELECT p.*, w.name_fr as wilaya_name FROM professionals p JOIN wilayas w ON p.wilaya_id = w.id";
    $params = [];

    if ($wilayaId) {
        $query .= " WHERE p.wilaya_id = ?";
        $params[] = $wilayaId;
    }

    $stmt = $pdo->prepare($query);
    $stmt->execute($params);
    sendResponse($stmt->fetchAll());
}

function getEstablishments($pdo) {
    $wilayaId = $_GET['wilaya_id'] ?? null;
    $type = $_GET['type'] ?? null; // PUBLIC or PRIVE

    $query = "SELECT e.*, w.name_fr as wilaya_name FROM establishments e JOIN wilayas w ON e.wilaya_id = w.id";
    $conditions = [];
    $params = [];

    if ($wilayaId) {
        $conditions[] = "e.wilaya_id = ?";
        $params[] = $wilayaId;
    }
    if ($type) {
        $conditions[] = "e.public_private = ?";
        $params[] = $type;
    }

    if (!empty($conditions)) {
        $query .= " WHERE " . implode(" AND ", $conditions);
    }

    $stmt = $pdo->prepare($query);
    $stmt->execute($params);
    sendResponse($stmt->fetchAll());
}

function searchDirectory($pdo) {
    $term = $_GET['q'] ?? '';
    $wilayaId = $_GET['wilaya_id'] ?? null;
    $type = $_GET['type'] ?? null; // professional, cabinet, public

    $results = [];

    if (!$type || $type === 'professional') {
        $query = "SELECT 'professional' as category, p.id, p.full_name as name, p.professional_type as sub_type, p.phone_primary as phone, p.address, w.name_fr as wilaya_name, p.verification_status
                  FROM professionals p JOIN wilayas w ON p.wilaya_id = w.id
                  WHERE (p.full_name LIKE ? OR p.professional_type LIKE ?)";
        $params = ["%$term%", "%$term%"];
        if ($wilayaId) {
            $query .= " AND p.wilaya_id = ?";
            $params[] = $wilayaId;
        }
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $results = array_merge($results, $stmt->fetchAll());
    }

    if (!$type || $type === 'cabinet' || $type === 'public') {
        $query = "SELECT 'establishment' as category, e.id, e.name, e.establishment_type as sub_type, e.phone_primary as phone, e.address, w.name_fr as wilaya_name, e.verification_status
                  FROM establishments e JOIN wilayas w ON e.wilaya_id = w.id
                  WHERE (e.name LIKE ? OR e.establishment_type LIKE ?)";
        $params = ["%$term%", "%$term%"];
        if ($wilayaId) {
            $query .= " AND e.wilaya_id = ?";
            $params[] = $wilayaId;
        }
        if ($type === 'cabinet') {
            $query .= " AND e.public_private = 'PRIVE'";
        } elseif ($type === 'public') {
            $query .= " AND e.public_private = 'PUBLIC'";
        }
        $stmt = $pdo->prepare($query);
        $stmt->execute($params);
        $results = array_merge($results, $stmt->fetchAll());
    }

    sendResponse($results);
}

function submitReport($pdo) {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!$data || !isset($data['record_id']) || !isset($data['record_type'])) {
        sendResponse(['error' => 'Missing data'], 400);
    }

    $stmt = $pdo->prepare("INSERT INTO directory_reports (record_type, record_id, report_type, description) VALUES (?, ?, ?, ?)");
    $stmt->execute([
        $data['record_type'],
        $data['record_id'],
        $data['report_type'],
        $data['description'] ?? ''
    ]);

    sendResponse(['success' => true]);
}
?>
