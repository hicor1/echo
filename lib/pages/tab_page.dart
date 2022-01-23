import 'package:flutter/material.dart';
import 'package:echo/pages/bible_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'favorite_page.dart';
import 'package:echo/controllers/other_controller.dart';

// Gex컨트롤러 객체 초기화
final OtherCtr = Get.put(OtherController());

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  List _pages = [
    BiblePage(),
    FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      GetBuilder<OtherController>(
          init: OtherController(),
          builder: (_) {
            return Center(
                child: _pages[OtherCtr.selectedPageIndex]); //return은 필수
          }
      ),
      bottomNavigationBar: Container(
          height: 80,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.white)],
              border: BorderDirectional(top: BorderSide(
                  color: Colors.grey, width: 0.4, style: BorderStyle.solid))
          ),
          child:
          GetBuilder<OtherController>(
            builder: (_) {
              return
                BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  // Fixed
                  backgroundColor: Colors.black,
                  // <-- This works for fixed
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.white,
                  onTap: (index) {
                    OtherCtr.PageChanged(index);
                  },
                  currentIndex: OtherCtr.selectedPageIndex,

                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book_outlined, size: 30),
                        label: '성경'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite_rounded, size: 30),
                        label: '즐겨찾기'),
                    //BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label:'더보기'),
                  ],
                );
            },
          )

      ),
    );
  }
}