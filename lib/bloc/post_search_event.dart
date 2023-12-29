part of 'post_search_bloc.dart';

@immutable
sealed class PostSearchEvent {}


final class PostSearchFetched extends PostSearchEvent {
  final String search;

  PostSearchFetched({required this.search});
}
