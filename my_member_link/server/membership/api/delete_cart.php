<?php

// Check if there is a post or not - to safeguarding request
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die;
}

include_once("dbconnect.php");
$cartid = ($_POST['cartid']);
// avoid comma

$sqldeletecart="DELETE FROM `tbl_cart` WHERE `cart_id` = '$cartid'";

if ($conn->query($sqldeletecart) === TRUE) {
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