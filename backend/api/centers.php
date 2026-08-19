<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $wilayaId = isset($_GET['wilaya_id']) ? (int)$_GET['wilaya_id'] : null;

    if (!$wilayaId) {
        sendResponse(['error' => 'wilaya_id is required'], 400);
    }

    $stmt = $pdo->prepare("SELECT * FROM centers WHERE wilaya_id = ? AND verification_status = 'VERIFIED' AND is_active = 1");
    $stmt->execute([$wilayaId]);
    $centers = $stmt->fetchAll();

    $result = array_map(function($c) {
        return [
            'id' => (int)$c['id'],
            'name' => $c['name'],
            'description' => $c['description'],
            'wilayaId' => (int)$c['wilaya_id'],
            'city' => $c['city'],
            'address' => $c['address'],
            'latitude' => $c['latitude'] ? (float)$c['latitude'] : null,
            'longitude' => $c['longitude'] ? (float)$c['longitude'] : null,
            'phone' => $c['phone'],
            'whatsapp' => $c['whatsapp'],
            'email' => $c['email'],
            'website' => $c['website'],
            'openingHours' => $c['opening_hours'],
            'services' => json_decode($c['services']),
            'verificationStatus' => $c['verification_status'],
            'isActive' => (bool)$c['is_active']
        ];
    }, $centers);

    sendResponse($result);
}
?>
