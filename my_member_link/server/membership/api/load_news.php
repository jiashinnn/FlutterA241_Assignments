<?php

include_once("dbconnect.php");

$results_per_page = 10;

if(isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;


$keyword = "";
if (isset($_GET['keyword'])) {
    $keyword = $_GET['keyword'];
    $sqlloadnews = "SELECT * FROM `tbl_news` WHERE `news_title` LIKE '%$keyword%' OR `news_details` LIKE '%$keyword%' ORDER BY `news_date` DESC";
} else {
    $sqlloadnews = "SELECT * FROM `tbl_news` ORDER BY `news_date` DESC";
}

$result = $conn->query($sqlloadnews);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadnews = $sqlloadnews ." LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadnews);

if ($result->num_rows > 0){
	$newsarray['news'] = array();
	while ($row = $result->fetch_assoc()){
		$news = array();
		$news['news_id'] = $row['news_id'];
		$news['news_title'] = $row['news_title'];
		$news['news_details'] = $row['news_details'];
		$news['news_date'] = $row['news_date'];
		$news['news_likes'] = $row['news_likes'];
		$news['news_saves'] = $row['news_saves'];
		array_push($newsarray['news'], $news);
	}
	$response = array('status' => 'success', 'data' => $newsarray, 'numofpage'=>$number_of_page, 'numofresult'=>$number_of_result,);
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