import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;
  final String membershipName;
  final String membershipPrice;

  const BillScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.membershipName,
    required this.membershipPrice,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late WebViewController wbcontroller;
  bool isLoading = true;
  late Timer countdownTimer;
  int remainingSeconds = 300;

  @override
  void initState() {
    super.initState();
    String userName = widget.userName.toString();
    String userEmail = widget.userEmail.toString();
    String userPhone = widget.userPhone.toString();
    String membershipName = widget.membershipName.toString();
    String membershipPrice = widget.membershipPrice.toString();
    wbcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://memberlinkapp.threelittlecar.com/membership/api/payment.php?userEmail=$userEmail&userName=$userName&userPhone=$userPhone&membershipName=$membershipName&membershipPrice=$membershipPrice'));

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          showTimeoutDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.red[300],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formatTime(remainingSeconds),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text('Transaction payment has failed.'),
        //         duration: Duration(seconds: 3),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: wbcontroller),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.red[300],
              ),
            ),
        ],
      ),
    );
  }

  String formatTime(int remainingSeconds) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: const Text(
            'Session Timeout',
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
              children: [
                Image.asset(
                  'assets/images/timeout.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your session has timed out. Please restart the payment process.',
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Close',
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
