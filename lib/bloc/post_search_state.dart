part of 'post_search_bloc.dart';

@immutable
sealed class PostSearchState {}

final class PostSearchInitial extends PostSearchState {}


final class PostSearchSuccess extends PostSearchState {
  final List<Post> postsList;

  PostSearchSuccess({required this.postsList});
}

final class PostSearchFailure extends PostSearchState {
  final String error;
  PostSearchFailure(this.error);
}

final class PostSearchLoading extends PostSearchState {}
