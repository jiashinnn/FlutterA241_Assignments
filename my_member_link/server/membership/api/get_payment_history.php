<?php
include_once("dbconnect.php");

// Check if 'email' is provided
if (isset($_POST['email'])) {
    $email = $_POST['email'];

    // Query to fetch user_id from email
    $sqlGetUserDetails = "SELECT `user_id`, `user_lastName`, `user_firstName`, `user_email`, `user_phone` FROM `tbl_users` WHERE `user_email` = ?";
    $stmtUser = $conn->prepare($sqlGetUserDetails);
    $stmtUser->bind_param("s", $email);
    $stmtUser->execute();
    $resultUser = $stmtUser->get_result();

    if ($resultUser->num_rows > 0) {
        $user = $resultUser->fetch_assoc();
        $userId = $user['user_id'];

        // Query to fetch payment history for the user
        $sqlLoadPayments = "
            SELECT 
                p.payment_id,
                m.membership_name,
                p.payment_amount,
                p.payment_status,
                p.payment_datePurchased,
                p.payment_dateExpired,
                p.receipt_id
            FROM 
                tbl_payments p
            JOIN 
                tbl_memberships m 
            ON 
                p.membership_id = m.membership_id
            WHERE 
                p.user_id = ?
            ORDER BY 
                p.payment_datePurchased DESC
        ";
        $stmtPayments = $conn->prepare($sqlLoadPayments);
        $stmtPayments->bind_param("i", $userId);
        $stmtPayments->execute();
        $resultPayments = $stmtPayments->get_result();

        if ($resultPayments->num_rows > 0) {
            $payments = array();
            while ($row = $resultPayments->fetch_assoc()) {
                $row['user_firstName'] = $user['user_firstName'];
                $row['user_lastName'] = $user['user_lastName'];
                $row['user_phone'] = $user['user_phone'];
                $row['user_email'] = $user['user_email'];
                $payments[] = $row;
            }
            $response = array('status' => 'success', 'data' => $payments);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'message' => 'No payment history found.');
            sendJsonResponse($response);
        }
        $stmtPayments->close();
    } else {
        $response = array('status' => 'failed', 'message' => 'User not found.');
        sendJsonResponse($response);
    }
    $stmtUser->close();
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
