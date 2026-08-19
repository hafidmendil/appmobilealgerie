<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->query("SELECT * FROM wilayas ORDER BY code ASC");
    $wilayas = $stmt->fetchAll();

    // Map database fields to model fields
    $result = array_map(function($w) {
        return [
            'id' => (int)$w['id'],
            'code' => $w['code'],
            'nameFr' => $w['name_fr'],
            'nameAr' => $w['name_ar'],
            'nameEn' => $w['name_en']
        ];
    }, $wilayas);

    sendResponse($result);
}
?>
