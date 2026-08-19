<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $wilayaId = isset($_GET['wilaya_id']) ? (int)$_GET['wilaya_id'] : null;

    if (!$wilayaId) {
        sendResponse(['error' => 'wilaya_id is required'], 400);
    }

    $stmt = $pdo->prepare("SELECT * FROM professionals WHERE wilaya_id = ? AND verification_status = 'VERIFIED' AND is_active = 1");
    $stmt->execute([$wilayaId]);
    $professionals = $stmt->fetchAll();

    $result = array_map(function($p) {
        return [
            'id' => (int)$p['id'],
            'fullName' => $p['full_name'],
            'title' => $p['title'],
            'specialty' => $p['specialty'],
            'wilayaId' => (int)$p['wilaya_id'],
            'city' => $p['city'],
            'address' => $p['address'],
            'latitude' => $p['latitude'] ? (float)$p['latitude'] : null,
            'longitude' => $p['longitude'] ? (float)$p['longitude'] : null,
            'phone' => $p['phone'],
            'whatsapp' => $p['whatsapp'],
            'email' => $p['email'],
            'photo' => $p['photo'],
            'biography' => $p['biography'],
            'languages' => json_decode($p['languages']),
            'sessionTypes' => json_decode($p['session_types']),
            'availability' => $p['availability'],
            'verificationStatus' => $p['verification_status'],
            'isActive' => (bool)$p['is_active']
        ];
    }, $professionals);

    sendResponse($result);
}
?>
