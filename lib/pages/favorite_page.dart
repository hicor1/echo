import 'package:echo/components/favorite_widget.dart';
import 'package:echo/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';


// Gex컨트롤러 객체 초기화
final FavoriteCtr = Get.put(FavoriteController());

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    FavoriteCtr.GetBibleSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FavoriteDropdownFilter(),
                    SizedBox(width: 10),
                    FavoriteDropdownBibles(),
                  ],
                ),
              ),
              // 즐겨찾기 리스트 결과 가져오기
              FavoriteResult()

            ],
          ),
        ),
      )

    );
  }
}
