import 'package:flutter/material.dart';
import 'package:echo/pages/bible_page.dart';

import 'favorite_page.dart';
//import 'package:echo/pages/home_page.dart';
//import 'package:echo/pages/search_page.dart';
//import 'package:echo/pages/my_page.dart';
//import 'package:echo/pages/favorite_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedPageIndex = 1;

  List _pages = [
    Text("Homepage"),
    BiblePage(),
    FavoritePage(),
    //Text("Mypage"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedPageIndex],),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color:Colors.white)],
            border: BorderDirectional(top: BorderSide(color: Colors.grey, width: 0.4, style: BorderStyle.solid))
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor: Colors.black, // <-- This works for fixed
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          currentIndex: this._selectedPageIndex,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.book_outlined, size: 30), label: '성경'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded, size: 30), label:'Favorite'),
            //BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label:'더보기'),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
}