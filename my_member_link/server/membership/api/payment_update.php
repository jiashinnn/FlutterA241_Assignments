<?php
include_once("dbconnect.php");

$userPhone = $_GET['userPhone'];
$membershipPrice = $_GET['membershipPrice'];
$membershipName = $_GET['membershipName'];
$userEmail = $_GET['userEmail'];
$userName = $_GET['userName'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true") {
    $paidstatus = "Paid";
} else {
    $paidstatus = "Failed";
}

$receiptid = $_GET['billplz']['id'];

$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, '44d0b296cd823c433ea7d1abee325e1f168ccd4e415ec339d5abe9a2290a04fd8fd5a12d442ace5cff81b5542b85af4aa5097fea8efd74c665fe8d31637fc081');


if ($signed === $data['x_signature']) {
    // Retrieve membership ID and duration
    $membershipQuery = $conn->prepare("SELECT membership_id, membership_duration FROM tbl_memberships WHERE membership_name = ?");
    $membershipQuery->bind_param("s", $membershipName);
    $membershipQuery->execute();
    $result = $membershipQuery->get_result();

    
    $membershipRow = $result->fetch_assoc();

    $membershipId = $membershipRow['membership_id'];
    $membershipDuration = $membershipRow['membership_duration'];
    
    // Calculate expiry date dynamically
    $currentDate = new DateTime(); // Current date (used for purchase date)
    $expiryDate = clone $currentDate; // Clone current date for expiry calculation

    if (strpos($membershipDuration, 'Year') !== false) {
        $durationValue = (int) filter_var($membershipDuration, FILTER_SANITIZE_NUMBER_INT);
        $expiryDate->modify("+$durationValue years");
    } elseif (strpos($membershipDuration, 'Month') !== false) {
        $durationValue = (int) filter_var($membershipDuration, FILTER_SANITIZE_NUMBER_INT);
        $expiryDate->modify("+$durationValue months");
    }

    // Format dates for database
    $formattedPurchaseDate = $currentDate->format('Y-m-d H:i:s');
    $formattedExpiryDate = $expiryDate->format('Y-m-d H:i:s');

    // Retrieve user ID
    $userIdQuery = $conn->prepare("SELECT user_id FROM tbl_users WHERE user_email = ?");
    $userIdQuery->bind_param("s", $userEmail);
    $userIdQuery->execute();
    $result = $userIdQuery->get_result();
    $userId = mysqli_fetch_assoc($result)['user_id'];
    
    $checkPendingQuery = $conn->prepare("SELECT payment_id FROM tbl_payments WHERE user_id = ? AND membership_id = ? AND payment_status = 'Pending'");
    $checkPendingQuery->bind_param("ii", $userId, $membershipId);
    $checkPendingQuery->execute();
    $pendingResult = $checkPendingQuery->get_result();

    
    // Update the pending payment
    if ($paidstatus === "Failed") {
        // If payment failed, revert the status to 'Pending' and clear receipt_id
        $updateQuery = $conn->prepare(
            "UPDATE tbl_payments 
            SET payment_status = 'Pending', receipt_id = NULL, payment_datePurchased = NOW(), payment_dateExpired = ? 
            WHERE user_id = ? AND membership_id = ? AND payment_status = 'Pending'"
        );
        $updateQuery->bind_param("sii", $formattedExpiryDate, $userId, $membershipId);
    } else {
        // If payment succeeded, update the details
        $updateQuery = $conn->prepare(
            "UPDATE tbl_payments 
            SET payment_amount = ?, payment_status = ?, payment_datePurchased = NOW(), payment_dateExpired = ?, receipt_id = ? 
            WHERE user_id = ? AND membership_id = ? AND payment_status = 'Pending'"
        );
        $updateQuery->bind_param("ssssii", $membershipPrice, $paidstatus, $formattedExpiryDate, $receiptid, $userId, $membershipId);
    }

    if ($updateQuery->execute()) {
        
        
        // Display receipt for successful or failed payment
        $statusColor = ($paidstatus == "Paid") ? "green" : "red";
        $statusIcon = ($paidstatus == "Paid") ? "fa-check-circle" : "fa-times-circle";
        $statusMessage = ($paidstatus == "Paid") ? "Payment Success!" : "Payment Failed";

        echo "
        <!DOCTYPE html>
        <html lang=\"en\">
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
            <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap\" rel=\"stylesheet\">
            <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css\">
            <style>
                body { font-family: 'Inter', sans-serif; background-color: #f4f4f9; margin: 0; display: flex; justify-content: center; align-items: center; height: 100vh; }
                .receipt-container { background: #fff; max-width: 600px; width: 100%; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); padding: 20px; }
                .receipt-header { text-align: center; margin-bottom: 20px; }
                .receipt-header i { font-size: 50px; color: $statusColor; }
                .receipt-header h2 { margin: 10px 0; color: $statusColor; font-weight: 700; }
                .receipt-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                .receipt-table th, .receipt-table td { text-align: left; padding: 10px; border-bottom: 1px solid #e6e6e6; }
                .receipt-footer { text-align: center; margin-top: 20px; }
                .receipt-footer a { text-decoration: none; color: #fff; background: #007bff; padding: 10px 20px; border-radius: 8px; font-weight: 600; transition: 0.3s; }
                .receipt-footer a:hover { background: #0056b3; }
            </style>
        </head>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    <i class=\"fa $statusIcon\"></i>
                    <h2>$statusMessage</h2>
                </div>
                <div class=\"receipt-body\">
                    <h3 style=\"font-weight: 600; margin-top: 10px; margin-bottom: 10px;\">Payment Details</h3>
                    <table class=\"receipt-table\">
                        <tbody>
                            <tr><td>Receipt ID</td><td style=\"text-align: right;\">$receiptid</td></tr>
                            <tr><td>Name</td><td style=\"text-align: right;\">$userName</td></tr>
                            <tr><td>Email</td><td style=\"text-align: right;\">$userEmail</td></tr>
                            <tr><td>Phone</td><td style=\"text-align: right;\">$userPhone</td></tr>
                            <tr><td>Membership Purchased</td><td style=\"text-align: right;\">$membershipName</td></tr>
                            <tr><td>Amount Paid</td><td style=\"text-align: right;\">RM $membershipPrice</td></tr>
                            <tr><td>Status</td><td style=\"color: $statusColor; text-align: right;\">$paidstatus</td></tr>
                            <tr><td>Expires On</td><td style=\"text-align: right;\">$formattedExpiryDate</td></tr>
                        </tbody>
                    </table>
                </div>
                <div class=\"receipt-footer\">
                    <a href=\"#\" onclick=\"window.history.back();\">Back</a>
                </div>
            </div>
        </body>
        </html>";
    } else {
        echo "Error inserting payment record: " . mysqli_error($conn);
    }
} else {
    echo "Invalid signature detected.";
}
?>