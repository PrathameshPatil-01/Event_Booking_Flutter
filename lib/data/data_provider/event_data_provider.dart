import 'dart:convert';

import 'package:http/http.dart' as http;

class EventDataProvider {
  Future<Map<String, dynamic>> fetchEventData(int eventId) async {
    final response = await http.get(
      Uri.parse(
          'https://sde-007.api.assignment.theinternetfolks.works/v1/event/$eventId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["content"]["data"];
    } else {
      throw Exception('Failed to load event');
    }
  }
}
