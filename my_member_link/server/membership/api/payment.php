<?php
//error_reporting(0);

$userEmail = $_GET['userEmail']; 
$userPhone = $_GET['userPhone']; 
$userName = $_GET['userName']; 
$membershipName = $_GET['membershipName'];
$membershipPrice = $_GET['membershipPrice']; 


$api_key = '4e95f2d9-651f-42e2-a86e-ef9b2d41cbc5';
$collection_id = 'v_i8u69q';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email' => $userEmail, 
    'mobile' => $userPhone, 
    'name' => $userName, 
    'amount' => ($membershipPrice * 100), 
    'description' => 'Payment for ' . $membershipName . ' by ' . $userName,
    'callback_url' => "https://memberlinkapp.threelittlecar.com/return_url", 
    'redirect_url' => "https://memberlinkapp.threelittlecar.com/membership/api/payment_update.php?"
        . "userEmail=" . urlencode($userEmail)
        . "&userPhone=" . urlencode($userPhone)
        . "&membershipName=" . urlencode($membershipName)
        . "&membershipPrice=" . urlencode($membershipPrice)
        . "&userName=" . urlencode($userName)
);

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

if (!$return) {
    die("No response from Billplz API. Please try again later.");
}

$bill = json_decode($return, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    die("Error decoding JSON response: " . json_last_error_msg());
}

if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
    exit;
} elseif (isset($bill['error']['message'])) {
    $errorMessage = $bill['error']['message'];
    die("Error creating bill: " . $errorMessage);
} else {
    die("Unexpected response from Billplz API: " . print_r($bill, true));
}

?>