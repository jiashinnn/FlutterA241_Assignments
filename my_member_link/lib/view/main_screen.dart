import 'dart:async';

import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';
import 'package:my_member_link/view/newsletter/new_news.dart';
import 'package:my_member_link/view/product/product_screen.dart';
import 'package:my_member_link/view/shared/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/view/newsletter/newsletter_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late double screenWidth, screenHeight;
  List imgData = [
    "assets/images/newsletter.png",
    "assets/images/event.png",
    "assets/images/member.png",
    "assets/images/payment.png",
    "assets/images/product.png",
    "assets/images/vetting.png",
  ];

  List titles = [
    "Newsletters",
    "Events",
    "Members",
    "Payment",
    "Product",
    "Vetting",
  ];

  late Timer timer;
  String lastUpdate = " ";
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    updateTime();
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => updateTime());
  }

  @override
  void dispose(){
    timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const MyDrawer(),
      body: Container(
        color: Colors.red[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 8.0),
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                height: screenHeight * 0.15,
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5),

                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Last update: $lastUpdate",
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      itemCount: imgData.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NewsletterScreen()),
                              );
                            }
                            if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductScreen()),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imgData[index],
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  titles[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        animation: animation,
        onPressed: () => animationController.isCompleted
            ? animationController.reverse()
            : animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.add,
        backgroundColor: Colors.red[300]!,
        items: <BubbleMenu>[
          BubbleMenu(
            title: "New Newsletter",
            iconColor: Colors.white,
            bubbleColor: Colors.red.shade300,
            icon: Icons.newspaper,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewNewsScreen()));
            },
          ),
          BubbleMenu(
            title: "New Event",
            iconColor: Colors.white,
            bubbleColor: Colors.red.shade300,
            icon: Icons.event,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void updateTime() {
    final now = DateTime.now();
  lastUpdate = df.format(now);
    setState(() {
      
    });
  }
}
