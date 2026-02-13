import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_project/data/model/comments.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:flutter_ecommerce_project/util/api_exeption.dart';
import 'package:flutter_ecommerce_project/util/auth_manager.dart';

abstract class ICommentsDatasource {
  Future<List<Comments>> getComments(String productId);

  Future<void> postComment(String productId, String comment);
}

class CommentsRemoteDatasource extends ICommentsDatasource {
  final Dio _dio = locator.get();
  final String userId = AuthManager.getID();

  @override
  Future<List<Comments>> getComments(String productId) async {
    Map<String, dynamic> qParams = {
      'filter': 'product_id="$productId"',
      'expand': 'user_id',
      'perPage': 1000
    };
    try {
      var response = await _dio.get(
        'collections/comment/records',
        queryParameters: qParams,
      );

      return response.data['items']
          .map<Comments>((jsonObject) => Comments.fromMapJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }

  @override
  Future<void> postComment(String productId, String comment) async {
    try {
      final response = await _dio.post(
        'collections/comment/records',
        data: {
          'text': comment,
          'user_id': userId,
          'product_id': productId,
        },
      );
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiExeption(0, 'Unknown Error');
    }
  }
}
