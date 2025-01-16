<?php
include_once("dbconnect.php");

// Check if 'user_id' is provided
if (isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];

    // SQL query to update membership statuses
    $sqlUpdateMembershipStatus = "
        UPDATE tbl_payments
        SET membership_status = CASE
            WHEN payment_dateExpired < NOW() THEN 'Expired'
            ELSE 'Active'
        END
        WHERE user_id = ?
    ";

    $stmt = $conn->prepare($sqlUpdateMembershipStatus);
    $stmt->bind_param("i", $user_id);

    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            $response = array(
                'status' => 'success',
                'message' => 'Membership statuses updated successfully.'
            );
        } else {
            $response = array(
                'status' => 'success',
                'message' => 'No memberships required updates.'
            );
        }
    } else {
        $response = array(
            'status' => 'failed',
            'message' => 'Failed to update membership statuses.'
        );
    }
    sendJsonResponse($response);
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
