import 'package:the_internet_folks/data/data_provider/event_data_provider.dart';
import 'package:the_internet_folks/models/post.dart';

class EventRepository {
  final EventDataProvider dataProvider;

  EventRepository(this.dataProvider);

  Future<Post> fetchEvent(int eventId) async {
    try {
      final eventData = await dataProvider.fetchEventData(eventId);
      return Post.fromJson(eventData);
    } catch (e) {
      throw Exception('Failed to fetch event: $e');
    }
  }
}
