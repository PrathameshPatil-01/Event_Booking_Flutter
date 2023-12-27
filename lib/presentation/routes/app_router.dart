import 'package:flutter/material.dart';
import 'package:the_internet_folks/presentation/Screens/event.dart';
import 'package:the_internet_folks/presentation/Screens/home.dart';
import 'package:the_internet_folks/presentation/Screens/search.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MyHomePage.routeName:
        final title = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: title,
          ),
        );
      case SearchList.routeName:
        return MaterialPageRoute(
          builder: (context) => const SearchList(),
        );
      case EventDetails.routeName:
        final eventId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => EventDetails(
            eventId: eventId,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Text('This page doesn\'t exist'),
          ),
        );
    }
  }
}
