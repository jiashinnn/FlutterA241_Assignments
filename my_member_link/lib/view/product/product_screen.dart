import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_member_link/models/product.dart';
import 'package:my_member_link/view/product/cart_screen.dart';
import 'package:my_member_link/view/product/product_detail_screen.dart';
import 'package:my_member_link/view/shared/my_drawer.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> productList = [];
  String status = "Loading...";
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;

  String selectedCategory = "All";
  String selectedSort = "Latest";
  List<String> categories = [
    "All",
    "T-shirts",
    "Caps",
    "Mugs",
    "Bags",
    "Stationeries",
    "Others"
  ];
  List<String> sortOptions = ["Latest", "Price up", "Price down"];
  String searchKeyword = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProductData();
  }

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
              'Product',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            actions: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: DropdownButton<String>(
                  value: selectedSort,
                  icon: const Icon(Icons.arrow_drop_down_circle_rounded),
                  underline: Container(),
                  dropdownColor: Colors.white,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {});
                      selectedSort = newValue;
                      curpage = 1;
                      loadProductData();
                    }
                  },
                  items:
                      sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                  icon: const Icon(Icons.shopping_cart_outlined))
            ],
          ),
          drawer: const MyDrawer(),
          body: GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: "Search products",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchKeyword = "";
                            curpage = 1;
                            loadProductData();
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
                    onChanged: (value) {
                      setState(() {
                        searchKeyword = value;
                        curpage = 1;
                        loadProductData();
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selectedCategory == category,
                            onSelected: (isSelected) {
                              setState(() {
                                selectedCategory = category;
                                curpage = 1;
                                loadProductData();
                              });
                            },
                            selectedColor: Colors.red[300],
                            backgroundColor: Colors.grey[600],
                            labelStyle: TextStyle(
                              color: selectedCategory == category
                                  ? Colors.white
                                  : Colors.grey[200],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Page $curpage of $numofpage / Total: $numofresult products",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Expanded(
                    child: productList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 50, color: Colors.red),
                                const SizedBox(height: 10),
                                Text(
                                  status,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      loadProductData(); // Reload data
                                    });
                                  },
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          )
                        : GridView.count(
                            childAspectRatio: 0.85,
                            crossAxisCount: 2,
                            children:
                                List.generate(productList.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                      )
                                    ],
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.red[100],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            product: productList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 8, 4, 4),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: Image.network(
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 120,
                                                      child: Image.asset(
                                                          "assets/images/na.png"),
                                                    ),
                                                width: screenWidth / 2,
                                                height: screenHeight / 6,
                                                fit: BoxFit.fitHeight,
                                                scale: 3.0,
                                                "${Myconfig.servername}/membership/assets/products/${productList[index].productFilename}"),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            truncateString(
                                                productList[index]
                                                    .productName
                                                    .toString(),
                                                18),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              "RM ${productList[index].productPrice.toString()}"),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(5, (i) {
                                              return Icon(
                                                Icons.star,
                                                color: i <
                                                        (productList[index]
                                                                .productRating ??
                                                            0)
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 16,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ),
                  SizedBox(
                    height: screenHeight * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: curpage > 1
                              ? () {
                                  setState(() {
                                    curpage = 1;
                                    loadProductData();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.first_page),
                          color: curpage > 1 ? Colors.black : Colors.grey,
                        ),
                        IconButton(
                          onPressed: curpage > 1
                              ? () {
                                  setState(() {
                                    curpage--;
                                    loadProductData();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_left),
                          color: curpage > 1 ? Colors.black : Colors.grey,
                        ),
                        Row(
                          children: List.generate(3, (index) {
                            int pageIndex = curpage - 1 + index;
                            if (pageIndex < 1 || pageIndex > numofpage) {
                              return const SizedBox.shrink();
                            }
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  curpage = pageIndex;
                                  loadProductData();
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
                        IconButton(
                          onPressed: curpage < numofpage
                              ? () {
                                  setState(() {
                                    curpage++;
                                    loadProductData();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_right),
                          color:
                              curpage < numofpage ? Colors.black : Colors.grey,
                        ),
                        IconButton(
                          onPressed: curpage < numofpage
                              ? () {
                                  setState(() {
                                    curpage = numofpage;
                                    loadProductData();
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.last_page),
                          color:
                              curpage < numofpage ? Colors.black : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
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

  void loadProductData() {
    String categoryFilter =
        selectedCategory == "All" ? "" : "&category=$selectedCategory";
    String searchFilter = searchKeyword.isEmpty ? "" : "&search=$searchKeyword";
    String sortFilter = selectedSort == "Latest" ? "" : "&sort=$selectedSort";
    http
        .get(Uri.parse(
            "${Myconfig.servername}/membership/api/load_product.php?pageno=$curpage$categoryFilter$searchFilter$sortFilter"))
        .then((response) {
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['product'];
          productList.clear();
          for (var item in result) {
            Product product = Product.fromJson(item);
            productList.add(product);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numofresult'].toString());
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }
}
