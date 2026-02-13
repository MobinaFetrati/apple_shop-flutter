import 'package:hive/hive.dart';
part 'card_item.g.dart';

@HiveType(typeId: 0)
class BasketItem {
  @HiveField(0)
  String id;
  @HiveField(1)
  String collectionId;
  @HiveField(2)
  String thumbnail;
  @HiveField(3)
  int discount_price;
  @HiveField(4)
  int price;
  @HiveField(5)
  String name;
  @HiveField(6)
  String categoryID;
  @HiveField(7)
  int? realPrice;
  @HiveField(8)
  num? persent;

  BasketItem(this.id, this.collectionId, this.thumbnail, this.discount_price,
      this.price, this.name, this.categoryID) {
    realPrice = price - discount_price;
    persent = ((price - realPrice!) / price) * 100;
    //this.thumbnail = 'https://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
  }
}
