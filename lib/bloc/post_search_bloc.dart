import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_internet_folks/data/repository/post_search_repository.dart';
import 'package:the_internet_folks/models/post.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  
  final PostSearchRepository postRepository;
  PostSearchBloc(this.postRepository) : super(PostSearchInitial()) {
    on<PostSearchFetched>(_getAllPosts);
  }


  void _getAllPosts(PostSearchFetched event, Emitter<PostSearchState> emit) async {
    final searchTerm = event.search;
    emit(PostSearchLoading());
    try {
      final List<Post> posts = await postRepository.getPosts(searchTerm);
      emit(PostSearchSuccess(postsList: posts));
    } catch (e) {
      emit(PostSearchFailure(e.toString()));
    }
  }
}
