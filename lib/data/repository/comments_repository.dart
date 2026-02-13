import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/datasource/Comments_datasource.dart';
import 'package:flutter_ecommerce_project/data/model/comments.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';

abstract class ICommentsRepository {
  Future<Either<String, List<Comments>>> getComments(String productId);
  Future<Either<String, String>> postComment(String productId, String comment);
}

class CommentsRepository extends ICommentsRepository {
  final ICommentsDatasource _datasource = locator.get();

  @override
  Future<Either<String, List<Comments>>> getComments(String productId) async {
    try {
      var response = await _datasource.getComments(productId);
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> postComment(
      String productId, String comment) async {
    try {
      var response = await _datasource.postComment(productId, comment);
      return right('نظر شما اضافه شد');
    } on ApiExeption catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
