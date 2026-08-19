<?php
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    // Validation
    if (!isset($data['userId'], $data['wilayaId'], $data['requestedDate'], $data['consentGiven']) || !$data['consentGiven']) {
        sendResponse(['error' => 'Missing required fields or consent not given'], 400);
    }

    try {
        $pdo->beginTransaction();

        $stmt = $pdo->prepare("INSERT INTO session_requests
            (user_id, professional_id, center_id, wilaya_id, requested_date, preferred_time, session_type, user_message, consent_given, consent_date, consent_version)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)");

        $stmt->execute([
            $data['userId'],
            $data['professionalId'] ?? null,
            $data['centerId'] ?? null,
            $data['wilayaId'],
            $data['requestedDate'],
            $data['preferredTime'] ?? null,
            $data['sessionType'] ?? null,
            $data['userMessage'] ?? null,
            $data['consentGiven'] ? 1 : 0,
            $data['consentVersion'] ?? '1.0'
        ]);

        $requestId = $pdo->lastInsertId();

        // Log consent in separate table for audit
        $stmtConsent = $pdo->prepare("INSERT INTO consents
            (user_id, request_id, consent_text, data_transmitted, recipient_id, recipient_type)
            VALUES (?, ?, ?, ?, ?, ?)");

        $dataTransmitted = json_encode(['fullName', 'wilaya', 'sessionType', 'userMessage', 'requestedDate']);
        $recipientId = $data['professionalId'] ?? $data['centerId'];
        $recipientType = isset($data['professionalId']) ? 'PROFESSIONAL' : 'CENTER';

        $stmtConsent->execute([
            $data['userId'],
            $requestId,
            "Les informations sélectionnées seront transmises au professionnel afin de traiter votre demande de séance.",
            $dataTransmitted,
            $recipientId,
            $recipientType
        ]);

        $pdo->commit();

        sendResponse(['id' => $requestId, 'status' => 'PENDING'], 201);

    } catch (Exception $e) {
        $pdo->rollBack();
        sendResponse(['error' => $e->getMessage()], 500);
    }
}
?>
