<?php

include_once("dbconnect.php");

$sqlloadmemberships = "SELECT * FROM `tbl_memberships` ORDER BY `membership_price` ASC";

$result = $conn->query($sqlloadmemberships);

if ($result->num_rows > 0) {
	$membershipsArray['memberships'] = array();
	while ($row = $result->fetch_assoc()) {
		$membership = array();
		$membership['membership_id'] = $row['membership_id'];
		$membership['membership_name'] = $row['membership_name'];
		$membership['membership_description'] = $row['membership_description'];
		$membership['membership_price'] = $row['membership_price'];
		$membership['membership_benefits'] = $row['membership_benefits'];
		$membership['membership_duration'] = $row['membership_duration'];
		$membership['membership_terms'] = $row['membership_terms'];
		$membership['membership_filename'] = $row['membership_filename'];
		$membership['membership_dateCreated'] = $row['membership_dateCreated'];
		array_push($membershipsArray['memberships'], $membership);
	}
	$response = array('status' => 'success', 'data' => $membershipsArray);
	sendJsonResponse($response);
} else {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

// Build the Json data response
function sendJsonResponse($sentArray)
{
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}
