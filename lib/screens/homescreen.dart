import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:metromony/pages/aboutus.dart';
import 'package:metromony/pages/favortitemember.dart';
import 'package:metromony/pages/editmember.dart';
import 'package:metromony/pages/addmember.dart';
import 'package:metromony/pages/userlist.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  List<Map<String, String>> favoriteUsers = [];

  void updateFavoriteUsers(List<dynamic> users) {
    setState(() {
      favoriteUsers = users
          .where((user) => user['isFavorite'] == 'true')
          .map((user) => Map<String, String>.from(user))
          .toList();
    });
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      UsersListPage(onFavoriteUpdate: updateFavoriteUsers),
      FavoriteMember(users: favoriteUsers),
      AboutUsPage(),
    ];
  }

  final List<List<Color>> _gradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    [Color(0xFF4ECDC4), Color(0xFF556270)],
    [Color(0xFFFFBE0B), Color(0xFFFF9B05)],
    [Color(0xFFFF4B2B), Color(0xFFFF416C)],
  ];

  final List<List<Color>> _appBarGradients = [
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFF556270), Color(0xFF4ECDC4)],
    [Color(0xFFFF9B05), Color(0xFFFFBE0B)],
    [Color(0xFFFF4B2B), Color(0xFFFF416C)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _appBarGradients[_page],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Member Management',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradients[_page],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            margin: EdgeInsets.only(top: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: _pages[_page],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradients[_page],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: Colors.transparent,
          color: Colors.white.withOpacity(0.95),
          buttonBackgroundColor: _gradients[_page][0],
          height: 60,
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(Icons.person_add,
                size: 30, color: _page == 0 ? Colors.white : _gradients[0][0]),
            Icon(Icons.favorite,
                size: 30, color: _page == 1 ? Colors.white : _gradients[1][0]),
            Icon(Icons.info,
                size: 30, color: _page == 2 ? Colors.white : _gradients[2][0]),
          ],
          onTap: (index) => setState(() => _page = index),
        ),
      ),
    );
  }
}
