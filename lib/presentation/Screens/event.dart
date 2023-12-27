import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_internet_folks/bloc/event_bloc.dart';
import 'package:the_internet_folks/models/post.dart';

class EventDetails extends StatefulWidget {
  static const routeName = '/eventdetails';
  final int eventId;

  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(EventFetched(eventId: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventFailure) {
            return Text(state.error);
          } else if (state is EventSuccess) {
            final event = state.event;
            return buildEvent(event);
          } else if (state != EventSuccess) {
            return Center(child: const CircularProgressIndicator());
          } else
            return Text("NO DATA AVAILABLE");
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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

  Widget buildEvent(Post event) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;
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
                height: sizeh > 600 ? sizeh * 0.4 : sizeh * 0.8,
                width: sizew,
                child: Image.network(
                  event.bannerImage ?? 'https://via.placeholder.com/500',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                      style: TextStyle(fontSize: 30, color: Colors.white),
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
                        'https://icons-for-free.com/iconfiles/png/256/user-131965017684610507.png',
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.network(
                        'https://icons-for-free.com/iconfiles/png/256/user-131965017684610507.png',
                      );
                    },
                  ),
                  title: Text(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      event.organiserName ?? 'Organiser Name'),
                  subtitle: const Text(
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      dateSubTitle),
                ),
                ListTile(
                  leading: Image.network(
                    "https://icons-for-free.com/iconfiles/png/256/gps+location+map+marker+icon-1320137092038384184.png",
                  ),
                  title: const Text(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      'Location'),
                  subtitle: Text(
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                  event.description ?? 'Description of the event goes here...',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
