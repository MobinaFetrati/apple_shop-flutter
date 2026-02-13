class Product {
  String id;
  String collectionId;
  String thumbnail;
  String description;
  int discount_price;
  int price;
  String popularity;
  String name;
  int quantity;
  String categoryID;
  int? realPrice;
  num? persent;

  Product(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.description,
    this.discount_price,
    this.price,
    this.popularity,
    this.name,
    this.quantity,
    this.categoryID,
  ) {
    realPrice = price - discount_price;
    persent = ((price - realPrice!) / price) * 100;
  }

  factory Product.fromJson(Map<String, dynamic> jsonObject) {
    return Product(
      jsonObject['id'],
      jsonObject['collectionId'],
      'https://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['description'],
      jsonObject['discount_price'],
      jsonObject['price'],
      jsonObject['popularity'],
      jsonObject['name'],
      jsonObject['quantity'],
      jsonObject['category'],
    );
  }
}
