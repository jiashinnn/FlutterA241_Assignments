<?php
include_once("dbconnect.php");

// Check if 'email' is provided
if (isset($_POST['email'])) {
    $email = $_POST['email'];

    
    $sqlLoadUser = "SELECT * FROM `tbl_users` WHERE `user_email` = ?";
    $stmt = $conn->prepare($sqlLoadUser);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $userDetails = $result->fetch_assoc();
        $response = array(
            'status' => 'success',
            'data' => array(
                'user_id' => $userDetails['user_id'],
                'user_firstName' => $userDetails['user_firstName'],
                'user_lastName' => $userDetails['user_lastName'],
                'user_email' => $userDetails['user_email'],
                'user_phone' => $userDetails['user_phone'],
                'user_dateRegister' => $userDetails['user_dateRegister']
            )
        );
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'User not found.');
        sendJsonResponse($response);
    }
    $stmt->close();
    $conn->close();
} else {
    $response = array('status' => 'failed', 'message' => 'Email parameter missing.');
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
