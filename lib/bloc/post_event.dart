part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

final class PostFetched extends PostEvent {}
