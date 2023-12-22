import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the_internet_folks/Screens/event.dart';
import 'package:the_internet_folks/Screens/search.dart';
import 'package:the_internet_folks/models/post.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Internet Folks',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Events'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Post>> postsFuture = getPosts();

  static Future<List<Post>> getPosts() async {
    var url = Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body)["content"]["data"];
    return body.map((e) => Post.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            style: const TextStyle(fontSize: 30, color: Colors.black),
            widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchList()),
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  Widget buildPosts(List<Post> posts) {
    final sizeh = MediaQuery.of(context).size.height;
    final sizew = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        String dateTimeString = post.dateTime!;
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('EEE, MMM dd • hh:mm a');
        String date = formatter.format(dateTime);
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetails(eventId: post.id!)),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            height: sizeh > 600 && sizew < 600 ? sizeh * 0.1 : sizeh * 0.25,
            width: double.maxFinite,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]!,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 100.0,
                  spreadRadius: 1.0,
                ), //BoxShadow
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ],
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(post.bannerImage!, fit: BoxFit.fill),
                    )),
                SizedBox(
                  width: sizew * 0.05,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          style:
                              const TextStyle(fontSize: 11, color: Colors.blue),
                          date),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          post.title!),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 13, color: Colors.grey[600]),
                          Text(
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                              post.venueCity!),
                          Text(
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                              "• ${post.venueCountry!}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
