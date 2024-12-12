<?php

// Check if there is a post or not - to safeguarding request
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die;
}

include_once("dbconnect.php");
$cart_id = $_POST["cart_id"];
$quantity = $_POST['quantity'];
// $title = addslashes($_POST['title']);
// $details = addslashes($_POST['details']);
// avoid comma

$sqlupdatecart="UPDATE `tbl_cart` SET `quantity`='$quantity', `total_price`= `price` * `quantity` WHERE `cart_id` = '$cart_id'";


if ($conn->query($sqlupdatecart) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}


// Build the Json data respon
function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}	

?>