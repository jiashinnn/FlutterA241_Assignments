import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/membership/bill_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MembershipPayment extends StatefulWidget {
  final String membershipName;
  final String membershipPrice;
  final String membershipFilename;

  const MembershipPayment({
    super.key,
    required this.membershipName,
    required this.membershipPrice,
    required this.membershipFilename,
  });

  @override
  State<MembershipPayment> createState() => _MembershipPaymentState();
}

class _MembershipPaymentState extends State<MembershipPayment> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = true;

  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    onTap() {
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Membership Review"),
        backgroundColor: Colors.red[300],
      ),
      body: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.red[300],
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.black54,)
                : SingleChildScrollView(
                    child: Container(
                      height: screenHeight * 0.75,
                      margin: const EdgeInsets.all(24.0),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Image.network(
                                      "${Myconfig.servername}/membership/assets/memberships/${widget.membershipFilename}",
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        "assets/images/na.png",
                                        fit: BoxFit.cover,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.membershipName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "RM ${widget.membershipPrice}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Your Details:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: nameController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: emailController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: phoneController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                          const Spacer(),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                proceedToPay();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BillScreen(
                                      membershipName: widget.membershipName,
                                      membershipPrice: widget.membershipPrice,
                                      userName: nameController.text,
                                      userEmail: emailController.text,
                                      userPhone: phoneController.text,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[300],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 15),
                              ),
                              child: const Text(
                                "Proceed to Pay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No email found. Please log in again."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final response = await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/get_user_details.php"),
      body: {"email": email},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          nameController.text =
              "${data['data']['user_firstName']} ${data['data']['user_lastName']}";
          emailController.text = data['data']['user_email'];
          phoneController.text = data['data']['user_phone'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to connect to server."),
        backgroundColor: Colors.red,
      ));
    }
  }
  
  Future<void> proceedToPay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString("user_id");
    final response = await http.post(
    Uri.parse("${Myconfig.servername}/membership/api/insert_payment.php"),
    body: {
      'user_id': user_id, 
      'payment_amount': widget.membershipPrice, 
      'membership_name': widget.membershipName, 
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to connect to the server."),
        backgroundColor: Colors.red,
      ),
    );
  }
  }

  
}
