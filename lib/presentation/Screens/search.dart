import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the_internet_folks/presentation/Screens/event.dart';
import 'package:the_internet_folks/models/post.dart';

class SearchList extends StatefulWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Search();
  }
}

class _Search extends State<SearchList> {
  String searchTerm = "";
  late Future<List<Post>> postsFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postsFuture = getPosts(searchTerm: searchTerm);
  }

  Future<List<Post>> getPosts({String searchTerm = ""}) async {
    var url = Uri.parse(
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$searchTerm");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List body = json.decode(response.body)["content"]["data"];
      return body.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            style: TextStyle(fontSize: 30, color: Colors.black), "Search"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(color: Colors.blue, Icons.search),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.black),
                  height: 27,
                  width: 2,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    showCursor: false,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        searchTerm = val;
                        postsFuture = getPosts(searchTerm: searchTerm);
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 14),
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: 'Type Event Name',
                      hintText: 'search...',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Post>>(
                future: postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final posts = snapshot.data!;
                    return buildPosts(posts);
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return const Text("No data available");
                  }
                },
              ),
            ),
          ),
        ],
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
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            height: sizeh > 600 && sizew < 600 ? sizeh * 0.1 : sizeh * 0.3,
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
                        date,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        post.title!,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
