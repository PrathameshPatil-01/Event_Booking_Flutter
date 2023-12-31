import 'package:http/http.dart' as http;

class PostDataProvider {
  Future<String> getPosts() async {
    var url = Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return (response.body);
    } else {
      throw Exception('Failed to load Posts');
    }
  }
}
