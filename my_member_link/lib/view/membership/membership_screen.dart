import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_member_link/models/memberhsip.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/view/membership/membership_details_screen.dart';
import 'package:my_member_link/view/membership/membership_payment.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<Membership> memberships = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMembershipsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text(
          "Memberships",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            tooltip: "Notifications",
          )
        ],
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.grey.shade400),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : memberships.isEmpty
                    ? const Center(
                        child: Text(
                          "No memberships available.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: memberships.length,
                        itemBuilder: (context, index) {
                          final membership = memberships[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: getGradientForPrice(double.tryParse(
                                      membership.membershipPrice ?? '0') ??
                                  0),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Image.network(
                                        "${Myconfig.servername}/membership/assets/memberships/${membership.membershipFilename}",
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/na.png",
                                          fit: BoxFit.cover,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        membership.membershipName ?? "No Name",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "\RM ${membership.membershipPrice} / ${membership.membershipDuration}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  membership.membershipDescription ??
                                      "No Description Provided",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MembershipDetailsScreen(
                                              membership: membership,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "See More Details",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => showConfirmationDialog(
                                          context, membership),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text("Buy Now"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void loadMembershipsData() {
    String url = "${Myconfig.servername}/membership/api/load_memberships.php";

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['memberships'];
          memberships.clear();
          for (var item in result) {
            Membership membership = Membership.fromJson(item);
            memberships.add(membership);
          }
          setState(() {
            isLoading = false;
          });

          if (memberships.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No memberships available."),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No memberships available."),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    }).catchError((err) {
      print("Error: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load memberships. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  LinearGradient getGradientForPrice(double price) {
    if (price < 100) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 129, 129),
          Color.fromARGB(255, 253, 144, 80),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (price < 250) {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 81, 177, 255),
          Color.fromARGB(255, 103, 202, 108),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 158, 125, 218),
          Color(0xFFF48FB1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  void showConfirmationDialog(BuildContext context, Membership membership) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/subscribe.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                "Purchase Confirmation",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "Are you sure you want to buy ${membership.membershipName} for RM ${membership.membershipPrice}?",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MembershipPayment(
                            membershipFilename:
                                membership.membershipFilename ?? "na.png",
                            membershipName:
                                membership.membershipName ?? "Unknown",
                            membershipPrice:
                                membership.membershipPrice ?? "0.00",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
