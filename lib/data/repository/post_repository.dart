import 'dart:convert';
import 'package:the_internet_folks/models/post.dart';
import 'package:the_internet_folks/data/data_provider/post_data_provider.dart';

class PostRepository {
  final PostDataProvider postDataProvider;
  PostRepository(this.postDataProvider);

  Future<List<Post>> getPosts(searchTerm) async {
    final postData = await postDataProvider.getPosts(searchTerm);
    try {
      final List body = jsonDecode(postData)["content"]["data"];
      return body.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch Posts: $e');
    }
  }
}
