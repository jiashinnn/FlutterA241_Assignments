import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_member_link/view/auth/login_screen.dart';
import 'package:my_member_link/view/main_screen.dart';
import 'package:my_member_link/view/newsletter/newsletter_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[300],
            ),
            child: const Text(
              "MyMemberLink", //Drawer Header
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            },
            title: const Text("Dashboard"),
            leading: const Icon(Icons.home),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewsletterScreen()));
            },
            title: const Text("Newsletters"),
            leading: const Icon(Icons.newspaper),
          ),
          ListTile(
            onTap: () {
             
            },
            title: const Text("Events"),
            leading: const Icon(Icons.event),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Members"),
            leading: const Icon(Icons.people),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Payment"),
            leading: const Icon(Icons.payment),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Product"),
            leading: const Icon(Icons.store),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Vetting"),
            leading: const Icon(Icons.verified),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Setting"),
            leading: const Icon(Icons.settings),
          ),
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
    Navigator.push(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}