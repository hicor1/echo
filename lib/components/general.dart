// 경고창 위젯(검색 글자수가 부족할때)

import 'package:echo/controllers/bible_controller.dart';
import 'package:echo/controllers/favorite_controller.dart';
import 'package:echo/controllers/other_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:getwidget/getwidget.dart';

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());
final FavoriteCtr = Get.put(FavoriteController());
final OtherCtr = Get.put(OtherController());

// 경고창 띄우기
void FlutterDialog(context) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("안내 메세지"),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "검색어는 최소 '2'글자로 해주세요.",
              ),
            ],
          ),
          actions: <Widget>[
            new ElevatedButton(
              child: new Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

// 다음페이지 넘어갈지 묻는 경고창
Future<void> IsMoveDialog(context, retult, index, IsFavoritePage) async {
  var verses_info = "${retult[index]['bcode']}. ${retult[index]['국문']}(${retult[index]['영문']}) :  ${retult[index]['cnum']}장  ${retult[index]['vnum']}절";
  await showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          //Dialog Main Title
          title: Column(
            children: <Widget>[
              new Text("안내 메세지"),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$verses_info\n구절로 이동하시겠습니까",),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
              child: new Text("확인"),
              onPressed: () {
                // 토스트메세지 띄우기
                PopToast("$verses_info로 이동합니다.");
                // 선택 구절을 메인에서 보여주기 위해 데이터 업데이트
                if(IsFavoritePage){
                  // "favorite_page"에서 호출한 이벤트라면 아래함수 발동
                  FavoriteCtr.FreeSearchContainerClick(index);
                  OtherCtr.PageChanged(0); // 즐찾페이지는 "스키린"가 아닌, "페이지"이므로 인덱스 조작으로 이동
                }else{
                  // "bible_page"에서 호출한 이벤트라면 아래함수발동
                  BibleCtr.FreeSearchContainerClick(index);
                  Get.back(); // 검색페이지는 "페이지"가 아닌, "스크린"이므로 돌아가기(back)으로 이동
                }
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: new Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}



// 토스트메세지 띄우기
void PopToast(String message){
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.white,
    fontSize: 20.0,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_SHORT
  );
}


// 멀티 셀렉트 ( 성경 이름 다중 선택 ) # https://docs.getwidget.dev/gf-multiselect/
class MultiSelect extends StatefulWidget {
  const MultiSelect({Key? key}) : super(key: key);

  @override
  _MultiSelectState createState() => _MultiSelectState();
}
class _MultiSelectState extends State<MultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFMultiSelect(
        items: ["아이템.1","아이템.2","아이템.3","아이템.4","아이템.5","아이템.6","아이템.7","아이템.8"],
        onSelect: (value) {
          print('selected $value ');
        },
        dropdownTitleTileText: 'Messi, Griezmann, Coutinho ',
        dropdownTitleTileColor: Colors.transparent, // 처음에 보여지는 드롭다운박스 색
        dropdownTitleTileMargin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        dropdownTitleTilePadding: EdgeInsets.all(10),
        dropdownUnderlineBorder: const BorderSide(
            color: Colors.blueGrey, width: 0),
        dropdownTitleTileBorder:
        Border.all(color: Colors.transparent, width: 0.7),
        dropdownTitleTileBorderRadius: BorderRadius.circular(5),
        expandedIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        collapsedIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
        ),
        submitButton: Text('OK'),
        dropdownTitleTileTextStyle: const TextStyle(
            fontSize: 14, color: Colors.white),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(6),
        type: GFCheckboxType.basic,
        activeBgColor: Colors.green.withOpacity(0.5),
        inactiveBorderColor: Colors.grey,
      ),
    );
  }
}
