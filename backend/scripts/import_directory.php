<?php
/**
 * Mental Health Directory Import Script
 * Parses TXT files and imports data into MySQL database.
 */

require_once __DIR__ . '/../api/config.php';

$fileFr = '/home/hafid/Téléchargements/annuaire_professionnel_psychologues_sante_mentale_algerie_58_wilayas_2026.txt';
$fileAr = '/home/hafid/Téléchargements/دليل_مهني_الأخصائيين_النفسيين_والصحة_النفسية_الجزائر_58_ولاية_2026.txt';

$report = [
    'total_lines' => 0,
    'professionals_imported' => 0,
    'establishments_imported' => 0,
    'public_structures' => 0,
    'wilayas_covered' => [],
    'duplicates_detected' => 0,
    'invalid_phones' => 0,
    'missing_addresses' => 0,
    'missing_sources' => 0,
    'needs_verification' => 0,
];

// 1. Get Wilayas from DB to map codes
$stmt = $pdo->query("SELECT id, code, name_fr FROM wilayas");
$wilayasMap = [];
while ($row = $stmt->fetch()) {
    $wilayasMap[$row['code']] = $row['id'];
}

// Helper to normalize phone
function normalizePhone($phone) {
    $phone = preg_replace('/[^0-9+]/', '', $phone);
    if (strpos($phone, '0') === 0 && strlen($phone) == 10) {
        return '+213' . substr($phone, 1);
    }
    return $phone;
}

// 2. Parse French File (Main source for now)
$content = file_get_contents($fileFr);
$lines = explode("\n", $content);
$report['total_lines'] = count($lines);

$section = '';
foreach ($lines as $line) {
    $line = trim($line);
    if (empty($line)) continue;

    if (strpos($line, 'CONTACTS PRIVÉS') !== false) {
        $section = 'private';
        continue;
    } elseif (strpos($line, 'STRUCTURES PUBLIQUES') !== false) {
        $section = 'public';
        continue;
    }

    // Skip headers and separators
    if (strpos($line, '---') !== false || strpos($line, 'Wilaya |') !== false) continue;

    $parts = explode('|', $line);
    if (count($parts) < 4) continue;

    if ($section === 'private') {
        // Private Professionals
        $wilayaCode = trim($parts[0]);
        $name = trim($parts[1]);
        $type = trim($parts[2]);
        $phone = trim($parts[3]);
        $address = isset($parts[4]) ? trim($parts[4]) : 'Non disponible';
        $source = isset($parts[5]) ? trim($parts[5]) : 'Inconnue';

        if (!isset($wilayasMap[$wilayaCode])) continue;

        $wilayaId = $wilayasMap[$wilayaCode];
        $report['wilayas_covered'][$wilayaCode] = true;

        // Check for duplicate (by name and phone in the same wilaya)
        $stmt = $pdo->prepare("SELECT id FROM professionals WHERE full_name = ? AND (phone_primary = ? OR phone_secondary = ?)");
        $stmt->execute([$name, $phone, $phone]);
        if ($stmt->fetch()) {
            $report['duplicates_detected']++;
            continue;
        }

        // Insert Professional
        $stmt = $pdo->prepare("INSERT INTO professionals (full_name, professional_type, phone_primary, address, wilaya_id, verification_status, last_verified_at) VALUES (?, ?, ?, ?, ?, 'A_VERIFIER', NOW())");
        $stmt->execute([$name, $type, $phone, $address, $wilayaId]);
        $profId = $pdo->lastInsertId();

        // Handle Source
        $stmt = $pdo->prepare("INSERT INTO sources (source_name, retrieved_at) VALUES (?, NOW()) ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id)");
        $stmt->execute([$source]);
        $sourceId = $pdo->lastInsertId();

        $stmt = $pdo->prepare("INSERT INTO professional_sources (professional_id, source_id, retrieved_at) VALUES (?, ?, NOW())");
        $stmt->execute([$profId, $sourceId]);

        $report['professionals_imported']++;
        if ($address === 'Non disponible') $report['missing_addresses']++;
        $report['needs_verification']++;

    } elseif ($section === 'public') {
        // Public Establishments
        $wilayaCode = trim($parts[0]);
        $name = trim($parts[1]);
        $type = trim($parts[2]);
        $service = isset($parts[3]) ? trim($parts[3]) : '';

        if (!isset($wilayasMap[$wilayaCode])) continue;

        $wilayaId = $wilayasMap[$wilayaCode];
        $report['wilayas_covered'][$wilayaCode] = true;

        // Check for duplicate
        $stmt = $pdo->prepare("SELECT id FROM establishments WHERE name = ? AND wilaya_id = ?");
        $stmt->execute([$name, $wilayaId]);
        if ($stmt->fetch()) {
            $report['duplicates_detected']++;
            continue;
        }

        // Insert Establishment
        $stmt = $pdo->prepare("INSERT INTO establishments (name, establishment_type, public_private, description, wilaya_id, verification_status, last_verified_at) VALUES (?, ?, 'PUBLIC', ?, ?, 'VERIFIE', NOW())");
        $stmt->execute([$name, $type, $service, $wilayaId]);
        $estId = $pdo->lastInsertId();

        $report['establishments_imported']++;
        $report['public_structures']++;
    }
}

// Generate Report Summary
echo "=== IMPORT REPORT ===\n";
echo "Total Lines: " . $report['total_lines'] . "\n";
echo "Professionals Imported: " . $report['professionals_imported'] . "\n";
echo "Establishments Imported: " . $report['establishments_imported'] . "\n";
echo "Public Structures: " . $report['public_structures'] . "\n";
echo "Wilayas Covered: " . count($report['wilayas_covered']) . " / 58\n";
echo "Duplicates Detected: " . $report['duplicates_detected'] . "\n";
echo "Missing Addresses: " . $report['missing_addresses'] . "\n";
echo "Needs Verification: " . $report['needs_verification'] . "\n";
echo "=====================\n";
?>
