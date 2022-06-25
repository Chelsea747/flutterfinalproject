// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = FloatingSearchBarController();
  List<String> urls = [];
  var searchBarHint = 'Search meme category...';
  @override
  void initState() {
    super.initState();
    // run anything here before screen shows up:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            // you need a listview to provide the index
            ListView.builder(
              itemCount: urls.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) =>
                  Image.network(urls[index], height: 640, width: 480),
            ),
            buildFloatingSearchBar(context)
          ],
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: searchBarHint,
      controller: controller,
      scrollPadding: const EdgeInsets.only(top: 1000000000, bottom: 0),
      transitionDuration: const Duration(milliseconds: 70),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 200),
      backdropColor: Colors.transparent,
      onQueryChanged: (input) {},

      /// When pressed "ENTER":
      onSubmitted: (input) {
        controller.close();
        getMeme(input);
        controller.query = '';
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: true,
        ),
      ],

      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.black,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  getMeme(query) {
    // ignore: avoid_print
    print(query); //printing here also works
    Uri uri = Uri.parse('https://meme-api.herokuapp.com/gimme/$query/30');
    //run in background
    http.get(uri).then((response) {
      var json = jsonDecode(response.body);
      List<dynamic> memes = json['memes'];
      // ignore: avoid_print
      print(uri);
      for (var item in memes) {
        //huh printing query works but it wont print the uri
        urls.add(item['url']);
      }
      searchBarHint = 'start scrolling! ...restart to search again';
      setState(() {});
    });
  }
}












/*
ListView.builder(
              itemCount: urls.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(urls[index], height: 640, width: 480),
                    ],
                  ),
                );
              }),
*/

  


