<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "membership_db";

// Define database connector
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error){ // failed
	die("Connection failed: " . $conn->connect_error);
}
?>