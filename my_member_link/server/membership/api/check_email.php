<?php

include_once("dbconnect.php");

header('Content-Type: application/json'); // Ensure JSON output

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    $response = array('status' => 'failed', 'message' => 'Invalid request method');
    echo json_encode($response);
    exit;
}

$email = $_POST['email'] ?? '';
if (empty($email)) {
    $response = array('status' => 'failed', 'message' => 'Email not provided');
    echo json_encode($response);
    exit;
}

$sqlemailcheck = "SELECT * FROM tbl_users WHERE user_email = ?";
$stmt = $conn->prepare($sqlemailcheck);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response = array('status' => 'exists', 'message' => 'Email already exists');
} else {
    $response = array('status' => 'available', 'message' => 'Email is available');
}

echo json_encode($response);

?>
