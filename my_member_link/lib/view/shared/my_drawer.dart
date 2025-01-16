import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/auth/login_screen.dart';
import 'package:my_member_link/view/main_screen.dart';
import 'package:my_member_link/view/membership/my_membership_screen.dart';
import 'package:my_member_link/view/newsletter/newsletter_screen.dart';
import 'package:my_member_link/view/payment/payment_screen.dart';
import 'package:my_member_link/view/product/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String userName = "User Name";
  String userEmail = "example@example.com";
  String userId = "";

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
                child: ClipOval(
                    child: Image(
              image: AssetImage('assets/images/yuqi.png'),
              fit: BoxFit.cover,
            ))),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[400]!, Colors.red[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            userId: userId,
                          )));
            },
            title: const Text("Dashboard"),
            leading: const Icon(Icons.home),
          ),
          const Divider(
              color: Colors.black54, thickness: 0.5, indent: 20, endIndent: 20),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewsletterScreen()));
            },
            title: const Text("Newsletters"),
            leading: const Icon(Icons.newspaper),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Events"),
            leading: const Icon(Icons.event),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyMembershipScreen(
                            userId: userId,
                          )));
            },
            title: const Text("Membership"),
            leading: const Icon(Icons.people),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaymentScreen()));
            },
            title: const Text("Payment"),
            leading: const Icon(Icons.payment),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductScreen()));
            },
            title: const Text("Product"),
            leading: const Icon(Icons.store),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Vetting"),
            leading: const Icon(Icons.verified),
          ),
          const Divider(
              color: Colors.black54, thickness: 0.5, indent: 20, endIndent: 20),
          ListTile(
            onTap: () {},
            title: const Text("Setting"),
            leading: const Icon(Icons.settings),
          ),
          const Divider(
              color: Colors.black54, thickness: 0.5, indent: 20, endIndent: 20),
          ListTile(
            onTap: () {
              signOutGoogle(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Log out successful"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Future<void> signOutGoogle(BuildContext context) async {
    await googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  Future<void> loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? id = prefs.getString("user_id");

    if (email == null || email.isEmpty || id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please log in again."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      userId = id; 
    });

    final response = await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/get_user_details.php"),
      body: {"email": email},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          userName =
              "${data['data']['user_firstName']} ${data['data']['user_lastName']}";
          userEmail = data['data']['user_email'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to fetch user details."),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Server error. Please try again."),
        backgroundColor: Colors.red,
      ));
    }
  }
}
