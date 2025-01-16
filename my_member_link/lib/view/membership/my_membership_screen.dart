import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/membership/membership_screen.dart';
import 'package:my_member_link/view/shared/my_drawer.dart';

class MyMembershipScreen extends StatefulWidget {
  final String userId;

  const MyMembershipScreen({super.key, required this.userId});

  @override
  State<MyMembershipScreen> createState() => _MyMembershipScreenState();
}

class _MyMembershipScreenState extends State<MyMembershipScreen> {
  List<dynamic> memberships = [];
  bool isLoading = true;
  final df = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    loadPurchasedMemberships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text("My Memberships"),
        backgroundColor: Colors.red[300],
        actions: [
          IconButton(
              onPressed: () {
                loadPurchasedMemberships();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : memberships.isEmpty
              ? const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/nothing.png'),
                      width: 250,
                      height: 250,
                    ),
                    Text("No memberships found.", style: TextStyle(fontSize: 18)),
                  ],
                ))
              : ListView.builder(
                  itemCount: memberships.length,
                  itemBuilder: (context, index) {
                    final membership = memberships[index];

                    String formattedStartDate = "N/A";
                    String formattedEndDate = "N/A";
                    if (membership['payment_datePurchased'] != null) {
                      formattedStartDate = df.format(
                        DateTime.parse(
                            membership['payment_datePurchased'].toString()),
                      );
                    }
                    if (membership['payment_dateExpired'] != null) {
                      formattedEndDate = df.format(
                        DateTime.parse(
                            membership['payment_dateExpired'].toString()),
                      );
                    }

                    Color statusColor =
                        membership['membership_status'] == 'Active'
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
                              Colors.red[100]!,
                              Colors.orange[50]!,
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
                                      membership['membership_name'],
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
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      membership['membership_status'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(
                                color: Colors.black26,
                                thickness: 1.0,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 18, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Start: $formattedStartDate",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.event_available,
                                      size: 18, color: Colors.black54),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Expires: $formattedEndDate",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[300],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Add Membership',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MembershipScreen()),
          );
        },
      ),
    );
  }

  Future<void> loadPurchasedMemberships() async {
    await updatePurchasedMembership();

    final response = await http.post(
      Uri.parse(
          "${Myconfig.servername}/membership/api/load_purchased_membership.php"),
      body: {"user_id": widget.userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          memberships = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['message'],
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to load purchased memberships",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> updatePurchasedMembership() async {
    final response = await http.post(
      Uri.parse(
          "${Myconfig.servername}/membership/api/update_purchased_membership.php"),
      body: {"user_id": widget.userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] != 'success') {
        print("Update purchased membership failed: ${data['message']}");
      }
    } else {
      print(
          "Failed to call update_purchased_membership.php. Status Code: ${response.statusCode}");
    }
  }
}
