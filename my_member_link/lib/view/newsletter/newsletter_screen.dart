import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:my_member_link/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/view/newsletter/edit_news.dart';
import 'package:my_member_link/view/shared/my_drawer.dart';
import 'package:my_member_link/view/newsletter/new_news.dart';

class NewsletterScreen extends StatefulWidget {
  const NewsletterScreen({super.key});

  @override
  State<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  List<News> newsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;
  String searchKeyword = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

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
            "Newsletter",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  loadNewsData();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        drawer: const MyDrawer(),
        body: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              // Search TextField at the Top
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: "Enter keyword",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchKeyword = "";
                          loadNewsData();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      searchKeyword = value;
                      loadNewsData(); 
                    });
                  },
                ),
              ),
              // Conditional Rendering: Show only if there are results
              newsList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          searchKeyword.isEmpty
                              ? "Loading..."
                              : "No newsletters found",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Page $curpage of $numofpage / Result: $numofresult newsletters",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: newsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 15),
                                  child: Slidable(
                                      startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        extentRatio: 0.3,
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              deleteDialog(index);
                                            },
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                truncateString(
                                                    newsList[index]
                                                        .newsTitle
                                                        .toString(),
                                                    30),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                df.format(DateTime.parse(
                                                    newsList[index]
                                                        .newsDate
                                                        .toString())),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            truncateString(
                                                newsList[index]
                                                    .newsDetails
                                                    .toString(),
                                                100),
                                            textAlign: TextAlign.justify,
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              showNewsDetailDialog(index);
                                            },
                                            icon:
                                                const Icon(Icons.arrow_forward),
                                          ),
                                        ),
                                      )),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.06,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First Page Button
                                IconButton(
                                  onPressed: curpage > 1
                                      ? () {
                                          setState(() {
                                            curpage = 1;
                                            loadNewsData();
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.first_page),
                                  color:
                                      curpage > 1 ? Colors.black : Colors.grey,
                                ),
                                // Previous Page Button
                                IconButton(
                                  onPressed: curpage > 1
                                      ? () {
                                          setState(() {
                                            curpage -= 1;
                                            loadNewsData();
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                  color:
                                      curpage > 1 ? Colors.black : Colors.grey,
                                ),
                                
                                Row(
                                  children: List.generate(3, (index) {
                                    int pageIndex = curpage - 1 + index;

                                    // Ensure we don't display pages that don't exist (below 1 or above total number of pages)
                                    if (pageIndex < 1 ||
                                        pageIndex > numofpage) {
                                      return const SizedBox.shrink();
                                    }

                                    return TextButton(
                                      onPressed: () {
                                        setState(() {
                                          curpage = pageIndex;
                                          loadNewsData();
                                        });
                                      },
                                      child: Text(
                                        pageIndex.toString(),
                                        style: TextStyle(
                                          color: curpage == pageIndex
                                              ? Colors.red
                                              : Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                // Next Page Button
                                IconButton(
                                  onPressed: curpage < numofpage
                                      ? () {
                                          setState(() {
                                            curpage += 1;
                                            loadNewsData();
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                  color: curpage < numofpage
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                                // Last Page Button
                                IconButton(
                                  onPressed: curpage < numofpage
                                      ? () {
                                          setState(() {
                                            curpage = numofpage;
                                            loadNewsData();
                                          });
                                        }
                                      : null,
                                  icon: const Icon(Icons.last_page),
                                  color: curpage < numofpage
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Transform.translate(
            offset: const Offset(0, -35),
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const NewNewsScreen()));
                loadNewsData();
              },
              backgroundColor: Colors.red[300],
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )),
      ),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadNewsData() {
    String url =
        "${Myconfig.servername}/membership/api/load_news.php?pageno=$curpage";
    if (searchKeyword.isNotEmpty) {
      url += "&keyword=$searchKeyword";
    }

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numofresult'].toString());
          setState(() {});
          
        } else {
          print("Error");
        }
      }
    });
  }

  void showNewsDetailDialog(int index) {
    showDialog(
        context: context, // ui current context
        builder: (context) {
          return AlertDialog(
            title: Text(newsList[index].newsTitle.toString()),
            content: Text(
              newsList[index].newsDetails.toString(),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  News news = newsList[index];

                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => EditNewsScreen(news: news)));
                  loadNewsData();
                },
                child: const Text("Edit?", style: TextStyle(color: Colors.black),),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close", style: TextStyle(color: Colors.black),))
            ],
          );
        });
  }

  void deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete \"${truncateString(newsList[index].newsTitle.toString(), 20)}\"",
              style: const TextStyle(fontSize: 18),
            ),
            content: const Text("Are you sure you want to delete this newsletter?"),
            actions: [
              TextButton(
                onPressed: () {
                  deleteNews(index);
                  Navigator.pop(context);
                },
                child: const Text("Yes", style: TextStyle(color: Colors.blueGrey),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No", style: TextStyle(color: Colors.red),),
              ),
            ],
          );
        });
  }

  void deleteNews(int index) {
    http.post(
        Uri.parse("${Myconfig.servername}/membership/api/delete_news.php"),
        body: {"newsid": newsList[index].newsId.toString()}).then((response) {
      //log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Success"),
            backgroundColor: Colors.green,
          ));
          loadNewsData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Delete Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
