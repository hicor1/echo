//https://newstory-of-dev.tistory.com/entry/Flutter-InstagramClon2-UIDesign
//https://sudarlife.tistory.com/entry/flutter-firebase-auth-%ED%94%8C%EB%9F%AC%ED%84%B0-%ED%8C%8C%EC%9D%B4%EC%96%B4%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%97%B0%EB%8F%99-%EB%A1%9C%EA%B7%B8%EC%9D%B8%EC%9D%84-%EA%B5%AC%EC%97%B0%ED%95%B4%EB%B3%B4%EC%9E%90-part-1?category=1176193
// https://centbin-dev.tistory.com/29
// https://bebesoft.tistory.com/24
// https://ichi.pro/ko/flutter-google-logeu-in-guhyeon-124831274771693
// https://kyungsnim.net/131

import 'package:echo/pages/root_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/bible_controller.dart';
import 'controllers/favorite_controller.dart';

// (앱 기동)
void main() {
  runApp(MyApp());
}

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());
final FavoriteCtr = Get.put(FavoriteController());

// (앱생성)
class MyApp extends StatelessWidget {
  // 정적 변수 설정
  Color pointcolor = Colors.black;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 상태값 불러오기(상당히 중요)
    BibleCtr.LoadPrefsData();
    FavoriteCtr.LoadPrefsData();

    // BibleCtr.Prefs_isLoading.value // 상태값 불러오기가 끝날때까지 대기 ( 비동기화 작업이므로 안기다리면 설정값 불러오기전에 시작됨 )
    //     ? const Center(child: CircularProgressIndicator())
    //     :

    return GetBuilder<BibleController>(
        init: BibleController(),
        builder: (_) {
          //상태값 불러오기 로딩이 완료되었는지 확인한다.
          return BibleCtr.Prefs_isLoading
              ? const Center(child: CircularProgressIndicator())
              : GetMaterialApp(
                  // 디버그 모드 해제
                  debugShowCheckedModeBanner: false,
                  title: '언제나 성경',
                  theme: new ThemeData(
                    fontFamily: '', // 향후 폰트 적용해보도록ㄱㄱ
                    scaffoldBackgroundColor: const Color(0x000000FF),
                  ),
                  home: RootPage(),
                );
        });
  }
}
