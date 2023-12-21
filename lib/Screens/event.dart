import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the_internet_folks/models/post.dart';

class EventDetails extends StatefulWidget {
  final int eventId;

  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  late Future<Post> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = fetchEvent(widget.eventId);
  }

  Future<Post> fetchEvent(int eventId) async {
    final response = await http.get(
      Uri.parse(
          'https://sde-007.api.assignment.theinternetfolks.works/v1/event/$eventId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body)["content"]["data"]);
    } else {
      throw Exception('Failed to load event');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Post>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            String dateTimeString = event.dateTime!;
            DateTime dateTime = DateTime.parse(dateTimeString);
            DateFormat formatter1 = DateFormat('dd MMMM, yyyy ');
            DateFormat formatter2 = DateFormat('EEEE • hh:mm a');
            String dateTitle = formatter1.format(dateTime);
            String dateSubTitle = formatter2.format(dateTime);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          event.bannerImage ??
                              'https://via.placeholder.com/500',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppBar(
                          iconTheme: const IconThemeData(color: Colors.white),
                          backgroundColor:
                              Colors.transparent, // Transparent app bar
                          elevation: 0, // No shadow
                          title: const Text(
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                              'Event Details'),
                          actions: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title ?? 'Event',
                          style: const TextStyle(fontSize: 35),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Image.network(
                            event.organiserIcon ??
                                'https://via.placeholder.com/500',
                          ),
                          title: Text(
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              event.organiserName ?? 'Organiser Name'),
                          subtitle: const Text(
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              'Organiser'),
                        ),
                        ListTile(
                          leading: Image.network(
                            "https://icons-for-free.com/iconfiles/png/256/date+event+month+plan+schedule+icon-1320196901021058544.png",
                          ),
                          title: Text(
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              dateTitle),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              dateSubTitle),
                        ),
                        ListTile(
                          leading: Image.network(
                            "https://icons-for-free.com/iconfiles/png/256/globe+location+world+icon-1320196720329899980.png",
                          ),
                          title: const Text(
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              'Location'),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              '${event.venueCity ?? ''}, ${event.venueCountry ?? ''}'),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description ??
                              'Description of the event goes here...',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add functionality for FAB here
        },
        label: Row(
          children: [
            const Text(style: TextStyle(fontSize: 22), 'Book Now'),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
            )
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
