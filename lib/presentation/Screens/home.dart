import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_internet_folks/bloc/event_bloc.dart';
import 'package:the_internet_folks/bloc/post_bloc.dart';
import 'package:the_internet_folks/bloc/post_search_bloc.dart';
import 'package:the_internet_folks/data/data_provider/event_data_provider.dart';
import 'package:the_internet_folks/data/data_provider/post_data_provider.dart';
import 'package:the_internet_folks/data/data_provider/post_search_data_provider.dart';
import 'package:the_internet_folks/data/repository/event_repository.dart';
import 'package:the_internet_folks/data/repository/post_repository.dart';
import 'package:the_internet_folks/data/repository/post_search_repository.dart';
import 'package:the_internet_folks/models/post.dart';
import 'package:the_internet_folks/presentation/Screens/event.dart';
import 'package:the_internet_folks/presentation/Screens/search.dart';
import 'package:the_internet_folks/presentation/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => PostRepository(PostDataProvider()),
        ),
        RepositoryProvider(
          create: (context) => PostSearchRepository(PostSearchDataProvider()),
        ),
        RepositoryProvider(
          create: (context) => EventRepository(EventDataProvider()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostBloc(context.read<PostRepository>()),
          ),
          BlocProvider(
            create: (context) => PostSearchBloc(context.read<PostSearchRepository>()),
          ),
          BlocProvider(
            create: (context) => EventBloc(context.read<EventRepository>()),
          ),
        ],
        child: MaterialApp(
          onGenerateRoute: _appRouter.onGenerateRoute,
          title: 'The Internet Folks',
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Events'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  static const routeName = '/';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostFetched());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            style: const TextStyle(fontSize: 30, color: Colors.black),
            widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  SearchList.routeName,
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostFailure) {
            return Text(state.error);
          } else if (state is PostSuccess) {
            final posts = state.postsList;
            return buildPosts(posts);
          } else if (state != PostSuccess) {
            return Center(child: const CircularProgressIndicator());
          } else
            return Center(child: Text("NO DATA AVAILABLE"));
        },
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
            Navigator.pushNamed(
              context,
              EventDetails.routeName,
              arguments: post.id,
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
