<?php

include_once("dbconnect.php");

$results_per_page = 10;

if(isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

//$sqlloadproduct = "SELECT * FROM `tbl_products` ORDER BY `product_date` DESC";
$selectedCategory = isset($_GET['category']) ? $_GET['category'] : 'All';
$searchKeyword = isset($_GET['search']) ? $_GET['search'] : '';
$sortFilter = isset($_GET['sort']) ? $_GET['sort'] : 'Latest';

$sqlloadproduct = "SELECT * FROM `tbl_products`";


// if ($sortFilter == "Latest") {
// 	$sqlloadproduct .= " ORDER BY `product_date` DESC";
// } elseif ($sortFilter == "Price: Low to High") {
// 	$sqlloadproduct .= " ORDER BY `product_price` ASC";
// } elseif ($sortFilter == "Price: High to Low") {
// 	$sqlloadproduct .= " ORDER BY `product_price` DESC";
// }
if ($selectedCategory != "All" || !empty($searchKeyword)) {
    $sqlloadproduct .= " WHERE";
    $conditions = [];
    if ($selectedCategory != "All") {
        $conditions[] = "`product_category` = '$selectedCategory'";
    }
    if (!empty($searchKeyword)) {
        $conditions[] = "`product_name` LIKE '%$searchKeyword%'";
    }
    $sqlloadproduct .= " " . implode(" AND ", $conditions);
}


if($sortFilter == "Price up"){
	$sqlloadproduct .= " ORDER BY `product_price` ASC";
}else if($sortFilter == "Price down"){
	$sqlloadproduct .= " ORDER BY `product_price` DESC";
} else {
	$sqlloadproduct .= " ORDER BY `product_date` DESC";
}


$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct ." LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0){
	$productarray['product'] = array();
	while ($row = $result->fetch_assoc()){
		$product = array();
		$product['product_id'] = $row['product_id'];
		$product['product_name'] = $row['product_name'];
		$product['product_description'] = $row['product_description'];
		$product['product_price'] = $row['product_price'];
		$product['product_quantity'] = $row['product_quantity'];
		$product['product_category'] = $row['product_category'];
		$product['product_filename'] = $row['product_filename'];
		$product['product_date'] = $row['product_date'];
		$product['product_rating'] = (int)$row['product_rating'];
		array_push($productarray['product'], $product);
	}
	$response = array('status' => 'success', 'data' => $productarray, 'numofpage'=>$number_of_page, 'numofresult'=>$number_of_result,);
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