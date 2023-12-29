import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_internet_folks/data/repository/post_repository.dart';
import 'package:the_internet_folks/models/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  PostBloc(this.postRepository) : super(PostInitial()) {
    on<PostFetched>(_getAllPosts);
  }


  void _getAllPosts(PostFetched event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final List<Post> posts = await postRepository.getPosts();
      emit(PostSuccess(postsList: posts));
    } catch (e) {
      emit(PostFailure(e.toString()));
    }
  }
}
