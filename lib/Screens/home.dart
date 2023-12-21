
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Internet Folks',
      theme: ThemeData(
        useMaterial3: true,
      ),
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
  void loadItems() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://sde-007.api.assignment.theinternetfolks.works/v1/event'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 1000) {
      print(await response.stream.bytesToString());
    } else {
      print(await response.stream.bytesToString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                loadItems();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: Center(
        child: ListView(children: [
          ListTile(
            leading: Image.network(
              "https://files.realpython.com/media/PyGame-Update_Watermarked.bb0aa2dfe80b.jpg",
              height: 100,
              width: 100,
            ),
          ),
        ]),
      ),
    );
  }
}

