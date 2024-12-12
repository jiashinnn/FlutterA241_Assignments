<?php

include_once("dbconnect.php");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$product_id = isset($_POST['product_id']) ? intval($_POST['product_id']) : 0;

if ($product_id > 0) {
    $sqlloadproduct = "SELECT * FROM `tbl_cart` WHERE `product_id` = '$product_id' ORDER BY `cart_date` DESC";
} else {
    $sqlloadproduct = "SELECT * FROM `tbl_cart` ORDER BY `cart_date` DESC";
}

$result = $conn->query($sqlloadproduct);


if ($result->num_rows > 0) {
    $cartArray = array();
    while ($row = $result->fetch_assoc()) {
        $cart = array();
        $cart['cart_id'] = $row['cart_id'];
        $cart['product_id'] = $row['product_id'];
        $cart['product_name'] = $row['product_name'];
        $cart['product_filename'] = $row['product_filename'];
        $cart['quantity'] = $row['quantity'];
		$cart['product_price'] = $row['price'];
        $cart['total_price'] = $row['total_price'];
        $cart['cart_date'] = $row['cart_date'];
        array_push($cartArray, $cart);
    }
	$response = array('status' => 'success', 'data' => $cartArray);
	sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

// Build the Json data response
function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}	

?>