// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
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

  final listController = ScrollController();

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

  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List<String> animatedListItems = [];
  int selectedIndex = -1;
  late Timer timer;

  @override
  void initState() {
    // run anything here before screen shows up:
    insertItems();

    super.initState();
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
              controller: listController,
              itemCount: memes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => MemeCard(meme: memes[index]),
            ),

            Positioned(
              top: 56,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: animation.drive(Tween(
                        begin: Offset(2, 0),
                        end: Offset(0, 0),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FilterChip(
                          label: Text(animatedListItems[index]),
                          onSelected: (selected) {
                            if (selected) {
                              getMeme(animatedListItems[index]);
                              clearItems();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            buildFloatingSearchBar(context),
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
      builder: (_, __) => SizedBox(),
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

      listController.animateTo(0,
          duration: Duration(milliseconds: 2000), curve: Curves.easeInOut);

      setState(() {});
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Could not find this category.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    });
  }

  void insertItems() {
    int count = 0;
    animatedListItems.clear();
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      animatedListItems.add(subreddits[count]);

      if (listKey.currentState != null) {
        listKey.currentState!.insertItem(animatedListItems.length - 1,
            duration: Duration(milliseconds: 300));
      }

      count += 1;
      if (count >= subreddits.length) {
        timer.cancel();
      }
    });
  }

  void clearItems() {
    timer.cancel();
    for (var i = animatedListItems.length - 1; i >= 0; i--) {
      listKey.currentState!.removeItem(i, (context, animation) => SizedBox());
    }
    animatedListItems.clear();
  }
}
