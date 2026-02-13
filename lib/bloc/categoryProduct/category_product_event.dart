abstract class CategoryProductEvent {}

class CategoryProductInitialize extends CategoryProductEvent {
  String categoryID;
  CategoryProductInitialize(this.categoryID);
}
