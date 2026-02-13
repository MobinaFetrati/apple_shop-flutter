class VariantType {
  String? id;
  String? name;
  String? title;
  VariantTypeEnum? type;

  VariantType(
    this.id,
    this.name,
    this.title,
    this.type,
  );

  factory VariantType.fromJson(Map<String, dynamic> jsonObject) {
    return VariantType(
      jsonObject['id'],
      jsonObject['name'],
      jsonObject['title'],
      _getTypeEnum(jsonObject['type']),
    );
  }
}

VariantTypeEnum _getTypeEnum(String type) {
  switch (type) {
    case 'Color':
      return VariantTypeEnum.COLOR;
      break;
    case 'Storage':
      return VariantTypeEnum.STORAGE;
      break;
    case 'Voltag':
      return VariantTypeEnum.VOLTAG;
      break;
    default:
      return VariantTypeEnum.COLOR;
  }
}

enum VariantTypeEnum { COLOR, STORAGE, VOLTAG }
