abstract class CommentsEvent {}

class CommentsInitializedEvent extends CommentsEvent {
  final String productID;
  CommentsInitializedEvent(this.productID);
}

class CommentsPostEvent extends CommentsEvent {
  final String productID;
  final String comment;
  CommentsPostEvent(this.productID, this.comment);
}
