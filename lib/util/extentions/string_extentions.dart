import 'dart:ui';

extension ColorParsing on String? {
  Color parseToColor() {
    String colorString = 'ff${this}';
    int hexColor = int.parse(colorString, radix: 16);
    return Color(hexColor);
  }

  String? extractValueFromQuery(String key) {
    int queryStartIndex = this!.indexOf('?');
    if (queryStartIndex == -1) return null;

    String query = this!.substring(queryStartIndex + 1);

    List<String> pairs = query.split('&');

    for (String pair in pairs) {
      List<String> keyValue = pair.split('=');
      if (keyValue.length == 2) {
        String currentKey = keyValue[0];
        String value = keyValue[1];

        if (currentKey == key) {
          return Uri.decodeComponent(value);
        }
      }
    }
    return null;
  }
}
