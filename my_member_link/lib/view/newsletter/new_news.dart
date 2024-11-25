import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
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
              "News Newsletter",
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
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Title",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: titleController,
                  decoration: commonDecoration.copyWith(
                    hintText: "Enter Newsletter Title",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    decoration: commonDecoration.copyWith(
                      hintText: "Enter Newsletter Details",
                    ),
                    maxLines: screenHeight ~/ 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  elevation: 10,
                  onPressed: onInsertNewsDialog,
                  minWidth: 400,
                  height: 50,
                  color: Colors.red[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Text(
                    "Insert",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]),
            ),
          )),
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
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
              "Add this newsletter?",
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
                  style: TextStyle(color: Colors.blueGrey),
                ),
                onPressed: () {
                  insertNews();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${Myconfig.servername}/membership/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));

          titleController.text = "";
          detailsController.text = "";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
