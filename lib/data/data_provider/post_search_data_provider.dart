import 'package:http/http.dart' as http;

class PostSearchDataProvider {
  Future<String> getPosts(String searchTerm) async {
    var url = Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$searchTerm");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return (response.body);
    } else {
      throw Exception('Failed to load Posts');
    }
  }
}
