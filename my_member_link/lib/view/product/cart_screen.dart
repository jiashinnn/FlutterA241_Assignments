import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_member_link/models/cart.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = [];
  bool isLoading = true;
  double totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red[300],
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : cartList.isEmpty
                    ? const Center(
                        child: Text(
                          "Your cart is empty!",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          final cart = cartList[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                extentRatio: 0.3,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDeleteConfirmationDialog(
                                          cart.cartId!);
                                    },
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ],
                              ),
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
                                child: ListTile(
                                  selectedTileColor: Colors.white,
                                  leading: Image.network(
                                    "${Myconfig.servername}/membership/assets/products/${cart.productFilename}",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                  title: Text(truncateString(
                                      cart.productName.toString(), 16)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "RM ${cart.price?.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          "Total: RM ${cart.totalPrice?.toStringAsFixed(2)}"),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if ((cart.quantity ?? 1) > 1) {
                                            updateQuantity(
                                              cart.cartId!,
                                              (cart.quantity ?? 1) - 1,
                                            );
                                          }
                                        },
                                      ),
                                      Text(cart.quantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          updateQuantity(
                                            cart.cartId!,
                                            (cart.quantity ?? 0) + 1,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.red[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: RM ${totalCost.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                  ),
                  child: const Text("Checkout",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
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

  void loadCartData() async {
    setState(() {
      isLoading = true;
    });
    await http
        .post(
      Uri.parse("${Myconfig.servername}/membership/api/load_cart.php"),
    )
        .then((response) {
      //print(response.body);
      //print(cartList);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success" && data['data'] != null) {
          cartList = (data['data'] as List)
              .map((json) => Cart.fromJson(json))
              .toList();
        } else {
          cartList = [];
        }
        totalCost = calculateTotalCost();
      } else {
        print("Error: ${response.statusCode}");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  double calculateTotalCost() {
    return cartList.fold(
      0.0,
      (sum, item) => sum + (item.totalPrice ?? 0),
    );
  }

  Future updateQuantity(String cartId, int newQuantity) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/update_cart.php"),
      body: {
        'cart_id': cartId,
        'quantity': newQuantity.toString(),
      },
    ).then((response) {
      //print(response.body);
      if (response.statusCode == 200) {
        loadCartData();
      } else {
        print("Error");
      }
    });
  }

  Future<void> showDeleteConfirmationDialog(String cartId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 30),
                    SizedBox(width: 10),
                    Text("Confirm Deletion"),
                  ],
                ),
                content: const Text(
                  "Are you sure you want to remove this item from your cart?",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style:
                        TextButton.styleFrom(foregroundColor: Colors.grey[700]),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      removeCartItem(cartId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future removeCartItem(String cartId) async {
    setState(() {
      isLoading = true;
    });
    await http.post(
      Uri.parse("${Myconfig.servername}/membership/api/delete_cart.php"),
      body: {
        'cartid': cartId,
      },
    ).then((response) {
      //print(response.body);
      if (response.statusCode == 200) {
        loadCartData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item removed from cart!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("Error");
      }
    });
  }
}
