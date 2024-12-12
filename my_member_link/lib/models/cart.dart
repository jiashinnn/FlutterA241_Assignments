class Cart {
  String? cartId;
  String? productId;
  String? productName;
  String? productFilename;
  int? quantity;
  double? price;
  double? totalPrice;
  String? cartDate;

  Cart({
    this.cartId,
    this.productId,
    this.productName,
    this.productFilename,
    this.quantity,
    this.price,
    this.totalPrice,
    this.cartDate,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productFilename = json['product_filename'];
    quantity = int.tryParse(json['quantity'].toString());
    price = double.tryParse(json['product_price'].toString());
    totalPrice = double.tryParse(json['total_price'].toString());
    cartDate = json['cart_date'];
  }

  // Converts a Cart instance to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_filename'] = productFilename;
    data['quantity'] = quantity;
    data['product_price'] = price;
    data['total_price'] = totalPrice;
    data['cart_date'] = cartDate;
    return data;
  }
}
