part of 'post_bloc.dart';


@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostSuccess extends PostState {
  final List<Post> postsList;

  PostSuccess({required this.postsList});
}

final class PostFailure extends PostState {
  final String error;
  PostFailure(this.error);
}

final class PostLoading extends PostState {}
