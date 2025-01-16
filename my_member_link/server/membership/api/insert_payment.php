<?php

// Check if there is a POST request or not - safeguard the request
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die;
}

include_once("dbconnect.php");

// Retrieve POST data
$userId = $_POST['user_id'];
$amount = $_POST['payment_amount'];
$membershipName = $_POST['membership_name'];

// Fetch membership ID and duration from tbl_memberships
$sqlFetchMembership = "SELECT membership_id, membership_duration FROM tbl_memberships WHERE membership_name = ?";
$stmtMembership = $conn->prepare($sqlFetchMembership);
$stmtMembership->bind_param("s", $membershipName);
$stmtMembership->execute();
$resultMembership = $stmtMembership->get_result();

if ($resultMembership->num_rows > 0) {
	$membership = $resultMembership->fetch_assoc();
	$membershipId = $membership['membership_id'];
	$membershipDuration = $membership['membership_duration'];

	// Calculate dateExpired based on membership_duration
	$durationValue = (int) filter_var($membershipDuration, FILTER_SANITIZE_NUMBER_INT);
	if (strpos($membershipDuration, 'Year') !== false) {
		$dateExpired = date('Y-m-d H:i:s', strtotime("+$durationValue years"));
	} elseif (strpos($membershipDuration, 'Month') !== false) {
		$dateExpired = date('Y-m-d H:i:s', strtotime("+$durationValue months"));
	} else {
		$response = array('status' => 'failed', 'message' => 'Invalid membership duration format.', 'data' => null);
		sendJsonResponse($response);
		die;
	}

	// Insert payment details into tbl_payments
	$paymentStatus = 'Pending';
	$membershipStatus = (strtotime($dateExpired) > time()) ? 'Active' : 'Expired';
	$receiptId = ''; // Set receipt ID to an empty string initially

	$sqlInsertPayment = "
		INSERT INTO tbl_payments (
			user_id, 
			membership_id, 
			payment_amount, 
			payment_status, 
			payment_datePurchased, 
			payment_dateExpired, 
			membership_status, 
			receipt_id
		) VALUES (?, ?, ?, ?, NOW(), ?, ?, ?)
	";
	$stmtInsert = $conn->prepare($sqlInsertPayment);
	$stmtInsert->bind_param(
		"iisssss",
		$userId,
		$membershipId,
		$amount,
		$paymentStatus,
		$dateExpired,
		$membershipStatus,
		$receiptId
	);

	if ($stmtInsert->execute()) {
		$response = array('status' => 'success', 'data' => null, 'message' => 'Payment details inserted successfully.');
		sendJsonResponse($response);
	} else {
		$response = array('status' => 'failed', 'data' => null, 'message' => 'Failed to insert payment details: ' . $conn->error);
		sendJsonResponse($response);
	}

	$stmtInsert->close();
} else {
	$response = array('status' => 'failed', 'data' => null, 'message' => 'Membership not found.');
	sendJsonResponse($response);
}

$stmtMembership->close();
$conn->close();

// Build the JSON response
function sendJsonResponse($sentArray) {
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}

?>
