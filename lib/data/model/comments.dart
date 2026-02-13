class Comments {
  String id;
  String text;
  String productId;
  String userId;
  String userThumnailUrl;
  String userName;
  String avatar;

  Comments(this.id, this.text, this.productId, this.userId,
      this.userThumnailUrl, this.userName, this.avatar);

  factory Comments.fromMapJson(Map<String, dynamic> jsonObject) {
    return Comments(
        jsonObject['id'],
        jsonObject['text'],
        jsonObject['product_id'],
        jsonObject['user_id'],
        'https://startflutter.ir/api/files/${jsonObject['expand']['user_id']['collectionName']}/${jsonObject['expand']['user_id']['id']}/${jsonObject['expand']['user_id']['avatar']}',
        // jsonObject['expand']['user_id']['name'],
        (jsonObject['expand']['user_id']['name'] != null &&
                jsonObject['expand']['user_id']['name']
                    .toString()
                    .trim()
                    .isNotEmpty)
            ? jsonObject['expand']['user_id']['name']
            : jsonObject['expand']['user_id']['username'],
        jsonObject['expand']['user_id']['avatar']);
  }
}
