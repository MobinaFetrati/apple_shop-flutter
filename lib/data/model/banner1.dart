class Banner1 {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? categoryId;
  Banner1(
    this.id,
    this.collectionId,
    this.thumbnail,
    this.categoryId,
  );

  factory Banner1.fromJson(Map<String, dynamic> jsonObject) {
    return Banner1(
      jsonObject['id'],
      jsonObject['collectionId'],
      'https://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
