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
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Yuqi Song",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: const Text(
              "yuqisong@gmail.com",
              style: TextStyle(
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
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
}
