import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/membership/bill_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<dynamic> paymentHistory = [];
  bool isLoading = true;
  String userName = '';
  String userPhone = '';
  String userEmail = '';
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.red[300],
        actions: [
          IconButton(
              onPressed: () {
                loadPaymentHistory();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentHistory.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/nothing.png'),
                        width: 250,
                        height: 250,
                      ),
                      Text(
                        "No payment history available.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: paymentHistory.length,
                  itemBuilder: (context, index) {
                    final payment = paymentHistory[index];

                    String formattedPurchaseDate = "N/A";
                    if (payment['payment_datePurchased'] != null) {
                      formattedPurchaseDate = df.format(
                        DateTime.parse(
                            payment['payment_datePurchased'].toString()),
                      );
                    }

                    String formattedExpiryDate = "N/A";
                    if (payment['payment_dateExpired'] != null) {
                      formattedExpiryDate = df.format(
                        DateTime.parse(
                            payment['payment_dateExpired'].toString()),
                      );
                    }

                    Color statusColor = payment['payment_status'] == "Paid"
                        ? Colors.green
                        : Colors.red;

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red[200]!,
                              Colors.orange[100]!,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      payment['membership_name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      payment['payment_status'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 18, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Purchased: $formattedPurchaseDate",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.event_available,
                                      size: 18, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Expired: $formattedExpiryDate",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (payment['payment_status'] == "Pending")
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BillScreen(
                                                userName: userName,
                                                userEmail: userEmail,
                                                userPhone: userPhone,
                                                membershipName:
                                                    payment['membership_name'],
                                                membershipPrice:
                                                    payment['payment_amount']
                                                        .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.payment,
                                          color: Colors.black54,
                                        ),
                                        label: const Text(
                                          "Pay",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow[100],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 5,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (payment['payment_status'] ==
                                            "Paid") {
                                          showReceiptDialog(payment);
                                        } else {
                                          showErrorDialog();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.receipt,
                                        color: Colors.black54,
                                      ),
                                      label: const Text(
                                        "View Receipt",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> loadPaymentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No email found. Please log in again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
          "${Myconfig.servername}/membership/api/get_payment_history.php"),
      body: {"email": email},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        setState(() {
          userName =
              "${data['data'][0]['user_firstName']} ${data['data'][0]['user_lastName']}";
          userPhone = data['data'][0]['user_phone'];
          userEmail = email;
          paymentHistory = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to fetch payment history."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showReceiptDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child:
                      Icon(Icons.check_circle, size: 60, color: Colors.green),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Payment Receipt",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Receipt No:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      payment['receipt_id'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Name:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Phone:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      userPhone,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Email:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      userEmail, // Assuming 'user_email' exists
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Date Paid:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      df.format(
                          DateTime.parse(payment['payment_datePurchased'])),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Membership:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      payment['membership_name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Amount Paid:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "RM ${payment['payment_amount']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final pdf = await generatePdf(payment);
                        await Printing.layoutPdf(onLayout: (format) => pdf);
                      },
                      icon: const Icon(Icons.download,
                          color: Colors.white, size: 20),
                      label: const Text("Download",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final pdfData = await generatePdf(payment);
                        await sendEmailWithReceipt(
                          recipientEmail: userEmail,
                          subject: 'Payment Receipt',
                          body:
                              'Thank you for your payment. Please find your receipt attached.',
                          pdfData: pdfData,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Receipt sent to email!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.email,
                          color: Colors.white, size: 20),
                      label: const Text("Send to Email",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: const Text(
            "Error",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 225,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/error.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Payment failed. No receipt available.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Uint8List> generatePdf(Map<String, dynamic> payment) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Payment Receipt',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Receipt No: ${payment['receipt_id']}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Name: $userName',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 5),
              pw.Text('Phone: $userPhone',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 5),
              pw.Text('Email: $userEmail',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Date Paid: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(payment['payment_datePurchased']))}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Membership: ${payment['membership_name']}',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Amount Paid: RM ${payment['payment_amount']}',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(
                'Thank you for your payment!',
                style:
                    pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  Future<void> sendEmailWithReceipt(
      {required String recipientEmail,
      required String subject,
      required String body,
      String? attachmentPath,
      required Uint8List pdfData}) async {
    // SMTP server details
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 587,
      username: 'jiashin0604@gmail.com',
      password: 'muci zzax ttwc lfcg',
    );

    // Email message
    final message = Message()
      ..from =
          const Address('jiashin0604@gmail.com', 'Membership') // Sender email
      ..recipients.add(recipientEmail) // Recipient email
      ..subject = subject
      ..text = body; // Plain text content

    // Attach a PDF file if provided
    if (attachmentPath != null) {
      message.attachments.add(FileAttachment(File(attachmentPath)));
    }

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } on MailerException catch (e) {
      print('Email not sent. $e');
      for (var problem in e.problems) {
        print('Problem: ${problem.code}: ${problem.msg}');
      }
    }
  }
}
