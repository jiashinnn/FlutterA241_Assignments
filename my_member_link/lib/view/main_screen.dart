import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyMemberLink"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[300],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOutGoogle(context);
            },
          ),
        ],
      ),
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              'assets/animation/robot.json',
              fit: BoxFit.contain,
              width: 400,
              height: 400,

            ),
          ),
          
         
        ],
      ),
    );
  }

  Future<void> signOutGoogle(BuildContext context) async {
    // Sign out from Google
    await googleSignIn.signOut();
    Navigator.pop(context);
  }
}
