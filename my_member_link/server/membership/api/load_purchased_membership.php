<?php
include_once("dbconnect.php");

// Check if 'user_id' is provided
if (isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];

    // SQL query to fetch purchased memberships
    $sqlLoadPurchasedMemberships = "
        SELECT 
            p.payment_id,
            p.user_id,
            p.membership_id,
            p.payment_amount,
            p.payment_status,
            p.payment_datePurchased,
            p.payment_dateExpired,
            p.membership_status,
            m.membership_name,
            m.membership_description,
            m.membership_duration
        FROM tbl_payments p
        JOIN tbl_memberships m ON p.membership_id = m.membership_id
        WHERE p.user_id = ? AND p.payment_status = 'Paid'
        ORDER BY p.payment_datePurchased DESC
    ";

    $stmt = $conn->prepare($sqlLoadPurchasedMemberships);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $purchasedMemberships = [];
        while ($row = $result->fetch_assoc()) {
            $purchasedMemberships[] = $row;
        }
        $response = array(
            'status' => 'success',
            'data' => $purchasedMemberships
        );
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'No memberships found.');
        sendJsonResponse($response);
    }
    $stmt->close();
    $conn->close();
} else {
    $response = array('status' => 'failed', 'message' => 'User ID parameter missing.');
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
