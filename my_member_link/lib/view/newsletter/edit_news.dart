import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_member_link/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.news.newsTitle.toString();
    detailsController.text = widget.news.newsDetails.toString();
  }

  late double screenWidth, screenHeight;

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
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
  );

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    onTap() {
      FocusScope.of(context).unfocus();
    }

    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: Colors.black.withOpacity(0.2),
        selectionHandleColor: Colors.black87,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: const Text(
            "Edit Newsletter",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  titleController.clear();
                  detailsController.clear();
                },
                icon: const Icon(Icons.delete_sweep_outlined))
          ],
        ),
        body: GestureDetector(
          onTap: onTap,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Title",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: titleController,
                      decoration:
                          commonDecoration.copyWith(hintText: "News Title")),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: screenHeight * 0.53,
                    child: TextField(
                      controller: detailsController,
                      decoration:
                          commonDecoration.copyWith(hintText: "News Details"),
                      maxLines: screenHeight ~/ 35,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                      elevation: 10,
                      onPressed: onUpdateNewsDialog,
                      minWidth: screenWidth,
                      height: 50,
                      color: Colors.red[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: const Text("Update",
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onUpdateNewsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update News?"),
            content: const Text("Are you sure you want to update this newsletter?"),
            actions: [
              TextButton(
                  onPressed: () {
                    updateNews();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes",
                      style: TextStyle(color: Colors.blueGrey))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No", style: TextStyle(color: Colors.red)))
            ],
          );
        });
  }

  void updateNews() {
    String title = titleController.text.toString();
    String details = detailsController.text.toString();

    http.post(
        Uri.parse("${Myconfig.servername}/membership/api/update_news.php"),
        body: {
          "newsid": widget.news.newsId.toString(),
          "title": title,
          "details": details
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
