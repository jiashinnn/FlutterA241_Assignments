import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/login_screen.dart';
import 'package:email_otp/email_otp.dart';

void main() {
  EmailOTP.config(
    appName: 'MyApp',
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'me@rohitchouhan.com',
    otpLength: 6,
  );
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  TextEditingController otpController = TextEditingController();
  bool isOtpSent = false;
  bool isOtpVerified = false;

  final commonDecoration = InputDecoration(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
  );

  @override
  Widget build(BuildContext context) {
    onTap() {
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
          backgroundColor: Colors.red[300],
        ),
        //backgroundColor: Colors.red[300],
        body: GestureDetector(
          onTap: onTap,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            // child: Container(
            //   padding: const EdgeInsets.all(20.0),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(15.0),
            //       boxShadow: const [
            //         BoxShadow(
            //             color: Colors.black26,
            //             blurRadius: 10,
            //             offset: Offset(0, 4)),
            //       ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/logo2.png",
                  fit: BoxFit.fitWidth,
                  width: 150,
                  height: 70,
                ),
                const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.email, color: Colors.red[300]),
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Send OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (await EmailOTP.sendOTP(email: emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("OTP has been sent"),
                          backgroundColor: Colors.green));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("OTP failed sent"),
                          backgroundColor: Colors.red));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300]),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.security, color: Colors.red[300]),
                    labelText: 'OTP',
                    hintText: 'Enter OTP',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 80,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool otpValid = await EmailOTP.verifyOTP(
                              otp: otpController.text,
                            );
                            if (otpValid) {
                              setState(() {
                                isOtpVerified = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("OTP verified successfully"),
                                    backgroundColor: Colors.green),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Invalid OTP"),
                                    backgroundColor: Colors.red),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("Verify",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: newPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obscurePassword,
                  enabled: isOtpVerified,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock, color: Colors.red[300]),
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      child: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obscureConfirmPassword,
                  enabled: isOtpVerified,
                  decoration: commonDecoration.copyWith(
                    prefixIcon: Icon(Icons.lock, color: Colors.red[300]),
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter new password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isOtpVerified ? resetPassword : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text("Reset Password",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/check_email.php"),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == "exists") {
        return true;
      }
    }
    return false;
  }

  Future<void> resetPassword() async {
    String email = emailController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;
    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in all fields"),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red),
      );
      return;
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]').hasMatch(newPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password must contain both letters and numbers"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register New Account?",
              style: TextStyle(),
            ),
            content: const Text(
              "Are you sure?",
              style: TextStyle(),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  await PasswordReset(email, newPassword, confirmPassword);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> PasswordReset(
      String email, String newPassword, String confirmPassword) async {
    try {
      // Send a POST request to the PHP server
      final response = await http.post(
        Uri.parse("${Myconfig.servername}/membership/api/reset_password.php"),
        body: {
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      // Handle the response from the server
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password Reset Successful"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Password reset failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server error, please try again later"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
