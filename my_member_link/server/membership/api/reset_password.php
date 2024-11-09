<?php

// Check if there is a post or not - to safeguard the request
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$email = $_POST['email'];
$newPassword = sha1($_POST['newPassword']);
$confirmPassword = sha1($_POST['confirmPassword']);

// Make sure both passwords match before updating the database
if ($newPassword !== $confirmPassword) {
    $response = array('status' => 'failed', 'data' => 'Passwords do not match');
    sendJsonResponse($response);
    die;
}

$sqlUpdatePassword = "UPDATE `tbl_users` SET `user_pass` = '$newPassword', `user_cPass` = '$confirmPassword' WHERE `user_email` = '$email'";

// Execute the query and check if it is successful
if ($conn->query($sqlUpdatePassword) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

// Build the Json data response
function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
