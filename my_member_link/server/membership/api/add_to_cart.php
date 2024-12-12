<?php

// Check if there is a post or not - to safeguarding request
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die;
}

include_once("dbconnect.php");

$product_id = intval($_POST['product_id']);
$quantity = intval($_POST['quantity']);

$sqlgetproduct = "SELECT `product_price`, `product_name`, `product_filename` 
                  FROM `tbl_products` WHERE `product_id` = '$product_id'";
$result = $conn->query($sqlgetproduct);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $price = $row['product_price'];
	$product_name = $row['product_name'];
    $product_filename = $row['product_filename'];
    $total_price = $price * $quantity;

    // Check if the product is already in the cart
    $check_cart = "SELECT * FROM `tbl_cart` WHERE `product_id` = '$product_id'";
    $check_result = $conn->query($check_cart);

    if ($check_result->num_rows > 0) {
        // Update quantity if product already exists in cart
        $update_cart = "UPDATE `tbl_cart` SET `quantity` = `quantity` + $quantity, `total_price` = `total_price` + $total_price WHERE `product_id` = '$product_id'";
        if ($conn->query($update_cart) === TRUE) {
            $response = array('status' => 'success', 'message' => 'Cart updated successfully.');
			sendJsonResponse($response);
        } else {
            $response = array('status' => 'error', 'message' => 'Failed to update cart.');
			sendJsonResponse($response);
        }
    } else {
        // Insert new product into cart
        $sqladdtocart = "INSERT INTO `tbl_cart` (`product_id`, `product_name`, `product_filename`, `quantity`, `price`, `total_price`) 
                        VALUES ('$product_id', '$product_name', '$product_filename', '$quantity', '$price', '$total_price')";
        if ($conn->query($sqladdtocart) === TRUE) {
            $response = array('status' => 'success', 'message' => 'Product added to cart.');
			sendJsonResponse($response);
        } else {
            $response = array('status' => 'error', 'message' => 'Failed to add product to cart.');
			sendJsonResponse($response);
        }
    }
} else {
    $response = array('status' => 'error', 'message' => 'Product not found.');
}




// if ($conn->query($sqlinsert) === TRUE) {
// 	$response = array('status' => 'success', 'data' => null);
//     sendJsonResponse($response);
// }else{
// 	$response = array('status' => 'failed', 'data' => null);
// 	sendJsonResponse($response);
// }


// Build the Json data respon
function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}	

?>