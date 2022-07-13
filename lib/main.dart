// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_application_final/model/meme.dart';
import 'package:flutter_application_final/widget/meme_card.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// target: https://cdn.dribbble.com/users/745402/screenshots/9317698/media/9a8bf1434f4ddbe4fbaabb6f9f253791.png?compress=1&resize=1000x750&vertical=top

main() => runApp(MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(),
      ),
    ));

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = FloatingSearchBarController();
  List<Meme> memes = [];
  var searchBarHint = 'Search meme category...';

  /// list of suggestions
  List<String> subreddits = [
    'Pics',
    'DamnThatsInteresting',
    'Wallpapers',
    'Art',
    'ProgrammerHumor',
    'Memes',
    'DankMemes',
    'WholesomeMemes',
    'Funny',
    'Meirl',
  ];

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
              itemCount: memes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => MemeCard(meme: memes[index]),
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
      transitionDuration: const Duration(milliseconds: 700),
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
      actions: [FloatingSearchBarAction.searchToClear(showIfClosed: true)],

      /// The list of suggestions to be shown in the search bar.
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              subreddits.length,
              (index) => Container(
                color: Colors.primaries[index % Colors.primaries.length],
                child: ListTile(
                  title: Text(
                    subreddits[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    controller.query = subreddits[index];
                    controller.close();
                    getMeme(subreddits[index]);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void getMeme(String query) {
    Uri uri = Uri.parse(
        'https://meme-api.herokuapp.com/gimme/${query.toLowerCase()}/30');

    http.get(uri).then((response) {
      var json = jsonDecode(response.body);

      memes.clear();
      for (var meme in json['memes']) {
        memes.add(Meme.fromJson(meme));
      }

      setState(() {});
    });
  }
}
