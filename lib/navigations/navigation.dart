import 'package:flutter/material.dart';
import '../movie/Home.dart';
import '../movie/Search.dart';
import '../movie/Profile.dart';
import '../movie/watchlist.dart';
import '../movie/Explore.dart';

class MyHomePage extends StatefulWidget {
  final id;
  final username;
  final List<Page> _pages = [
    Page('Home', Icons.home, 30),
    Page('search', Icons.search, 30),
    Page('Explore', Icons.question_answer_rounded, 30),
    Page('library', Icons.playlist_play_sharp, 35),
    Page('profile', Icons.person_outline, 30),
  ];

  MyHomePage({Key key, @required this.id, this.username}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  void _openPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void initState() {
    super.initState();
    setState(() {
      _currentPageIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List routes = [
      Home(
        id: widget.id,
        username: widget.username,
      ),
      Search(),
      Explore(id: widget.id, username: widget.username),
      Watchlist(id: widget.id, username: widget.username),
      Profile(id: widget.id, username: widget.username),
    ];
    return Scaffold(
      body: routes[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _currentPageIndex,
        items: widget._pages
            .map((Page page) => BottomNavigationBarItem(
                  icon: Icon(
                    page.iconData,
                    size: page.size,
                  ),
                  title: Text(page.title),
                ))
            .toList(),
        onTap: _openPage,
      ),
    );
  }
}

class Page {
  final String title;
  final IconData iconData;
  final double size;
  Page(this.title, this.iconData, this.size);
}
