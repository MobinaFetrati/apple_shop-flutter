import 'package:bloc/bloc.dart';
import 'package:flutter_ecommerce_project/bloc/comments/comments_event.dart';
import 'package:flutter_ecommerce_project/bloc/comments/comments_state.dart';
import 'package:flutter_ecommerce_project/data/repository/comments_repository.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  ICommentsRepository repository;

  CommentsBloc(this.repository) : super(CommentsLoadingState()) {
    on<CommentsInitializedEvent>((event, emit) async {
      final response = await repository.getComments(event.productID);
      emit(CommentsResponseState(response));
    });

    on<CommentsPostEvent>((event, emit) async {
      emit(CommentsLoadingState());

      await repository.postComment(event.productID, event.comment);
      final response = await repository.getComments(event.productID);
      emit(CommentsPostLoadingState(false));
      emit(CommentsResponseState(response));
    });
  }
}
