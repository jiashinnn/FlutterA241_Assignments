class Product {
  String? productId;
  String? productName;
  String? productDescription;
  String? productPrice;
  String? productQuantity;
  String? productCategory;
  String? productFilename;
  String? productDate;
  int? productRating;

  Product({
      this.productId,
      this.productName,
      this.productDescription,
      this.productPrice,
      this.productQuantity,
      this.productCategory,
      this.productFilename,
      this.productDate,
      this.productRating,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    productQuantity = json['product_quantity'];
    productCategory = json['product_category'];
    productFilename = json['product_filename'];
    productDate = json['product_date'];
    productRating = json['product_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_price'] = productPrice;
    data['product_quantity'] = productQuantity;
    data['product_category'] = productCategory;
    data['product_filename'] = productFilename;
    data['product_date'] = productDate;
    data['product_rating'] = productRating;
    return data;
  }
}