import 'package:dartz/dartz.dart';
import 'package:flutter_ecommerce_project/data/model/comments.dart';

abstract class CommentsState {}

class CommentsLoadingState extends CommentsState {}

class CommentsResponseState extends CommentsState {
  Either<String, List<Comments>> response;
  CommentsResponseState(this.response);
}

class CommentsPostLoadingState extends CommentsState {
  final bool isLoading;
  CommentsPostLoadingState(this.isLoading);
}

class CommentsPostResponseState extends CommentsState {
  Either<String, String> response;
  CommentsPostResponseState(this.response);
}
