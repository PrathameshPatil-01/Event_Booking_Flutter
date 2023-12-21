import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  // function to display fetched data on screen
  Widget buildPosts(List<Post> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        String dateTimeString = post.dateTime!;
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('EEE, MMM dd • hh:mm a');
        String date = formatter.format(dateTime);
        return InkWell(
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            height: 100,
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(flex: 2, child: Image.network(post.bannerImage!)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date, // Style within Text constructor
                        style:
                            const TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        post.title!, // Style within Text constructor
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
