
import 'package:echo/components/general.dart';
import 'package:echo/controllers/bible_controller.dart';
import 'package:echo/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:word_break_text/word_break_text.dart';

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());
// Gex컨트롤러 객체 초기화
final FavoriteCtr = Get.put(FavoriteController());

// 성경(bibles)선택 드랍다운 위젯 !!!!
class FavoriteDropdownBibles extends StatelessWidget {
  const FavoriteDropdownBibles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(50.0)
        ),
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child:
            // GetX를 쓰기위해 "GetBuilder"로 덮어줌
            GetBuilder<FavoriteController>(
              init: FavoriteController(), // 이거 중요한듯?..
              builder: (controller){
                return
                  DropdownButton<String>(
                    value: FavoriteCtr.FavoriteBibleName,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30, //this inicrease the size
                    elevation: 2,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      FavoriteCtr.FavoriteUpdateSelectedDropdownValue(newValue);
                    },
                    items: BibleCtr.DropdownValueList // 성경 목록은 'bible_controller'것을 같이쓰자 ㄱㄱ
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_add_rounded),
                            Text("   $value", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: value == FavoriteCtr.FavoriteBibleName ? FontWeight.w900 : FontWeight.w300),),
                          ],
                        ),
                      );
                    }).toList(),
                  );
              },
            )
        )
    );
  }
}


// 필터선택 드롭다운
class FavoriteDropdownFilter extends StatelessWidget {
  const FavoriteDropdownFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(50.0)
        ),
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child:
            // GetX를 쓰기위해 "GetBuilder"로 덮어줌
            GetBuilder<FavoriteController>(
              init: FavoriteController(), // 이거 중요한듯?..
              builder: (controller){
                return
                  DropdownButton<String>(
                    value: FavoriteCtr.SelectedFilter,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30, //this inicrease the size
                    elevation: 2,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      FavoriteCtr.FavoriteUpdateSelectedDropdownFilter(newValue);
                    },
                    items: FavoriteCtr.DropdownFilterList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            //Icon(Icons.filter_alt),
                            Container(
                              child: Text("   $value", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: value == FavoriteCtr.SelectedFilter ? FontWeight.w900 : FontWeight.w300),)),
                          ],
                        ),
                      );
                    }).toList(),
                  );
              },
            )
        )
    );
  }
}


// 즐겨찾기 표시 위젯
class FavoriteResult extends StatefulWidget {
  const FavoriteResult({Key? key}) : super(key: key);

  @override
  _FavoriteResultState createState() => _FavoriteResultState();
}

class _FavoriteResultState extends State<FavoriteResult> {
  @override
  Widget build(BuildContext context) {
    return
      GetBuilder<FavoriteController>(
          init: FavoriteController(),
          builder: (_){
            return Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Scrollbar(
                  //controller: , // 스크롤 조작이 필요하다면 할당 ㄱㄱ
                  thickness: 3,
                  child: ListView.builder(
                    //controller: ,// 스크롤 조작이 필요하다면 할당 ㄱㄱ
                    itemCount: FavoriteCtr.FavoriteList.length,
                    itemBuilder: (context, index) {
                      // 아래는 변수 및 함수 정의
                      var result = FavoriteCtr.FavoriteList; // 결과 할당
                      // 날짜 받아오는 함수 정의// 시간문자열(yyyy년 MM월 DD일 EE HH:mm:ss a)을 시간으로 변경하고 밀리세컨드는 없애기
                      String GetDate(int index){
                        return DateFormat('M.DD\nEE').format(DateTime.parse(result[index]["bookmark_updated_at"]));
                      }
                      // 전날 날짜 받아오는 함수 정의
                      String GetForwardDate(int index){
                        if (index==0){//index-1오류를 피하기위해 임의 데이터를 넣어준다
                          return '9999년 99월 99일';
                        }else{
                          return GetDate(index-1);
                        }
                      }
                      // 여기부터 위젯 발사
                      return
                        Column(

                          children: [
                            // 날짜가 같을때는 구분선을 짧게 그어준다
                            Divider(
                                color: Colors.white,
                                thickness:GetForwardDate(index)==GetDate(index)? 0.5 : 1.0 ,
                                indent: GetForwardDate(index)==GetDate(index)? 70 : 0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 날짜정보 뿌리기
                                SizedBox(
                                  width: 70,
                                  child: Text(GetForwardDate(index)==GetDate(index)? "" : "${GetDate(index)}", textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: BibleCtr.Textsize, color: Colors.white)),
                                ),
                                // 즐겨찾기 버튼 + 성경구절 뿌리기
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${result[index]["국문"]}(${result[index]["영문"]}) ${result[index]["cnum"]}장 ${result[index]["vnum"]}절", style: TextStyle(fontSize: BibleCtr.Textsize*0.2+10,color: Colors.grey.withOpacity(1.0))),
                                            // 즐겨찾기 버튼 추가
                                            IconButton(
                                                iconSize: 25,
                                                padding: EdgeInsets.zero, // 아이콘 패딩 없애기
                                                constraints: BoxConstraints(), // 아이콘 패딩 없애기
                                                icon : FavoriteCtr.TempMainBookmarkedList[index] == 1? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                                                color: FavoriteCtr.TempMainBookmarkedList[index]== 1? Colors.red : Colors.grey,
                                                onPressed: () async {
                                                  // 북마크 해제인경우 안내창 띄우기
                                                  if (FavoriteCtr.TempMainBookmarkedList[index] == 1) {
                                                    // 안내창 띄우기
                                                    String Alert = await showDialog(
                                                      context: context,
                                                      barrierDismissible: false, // user must tap button!
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('즐겨찾기를 해제하시겠습니까?'),
                                                          content: Text("즐겨찾기 해제를 원하실경우 '예' 버튼을 눌러주세요"),
                                                          actions: <Widget>[
                                                            OutlinedButton(
                                                              child: Text('예'),
                                                              onPressed: () {
                                                                Navigator.pop(context, "예");
                                                                // 즐겨찾기 해제동작 입력
                                                                // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                                                                FavoriteCtr.UpdateBookmarked(
                                                                    result[index]['_id'], // ID
                                                                    FavoriteCtr.TempMainBookmarkedList[index] // 현재상태
                                                                );
                                                                // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                                                                FavoriteCtr.FrequentlyUpdateFavoriteBookmarkedList(index);
                                                                // 즐겨찾기 해제 Alert
                                                                showAlertDialog2(context);
                                                                // 즐겨찾기 등록 안내메세지 토스트(Toast)
                                                                PopToast("${result[index]['bcode']}.${result[index]['국문']}( ${result[index]['영문']}) : ${result[index]['cnum']}장 ${result[index]['vnum']}절${FavoriteCtr.TempMainBookmarkedList[index] == 1? " 즐겨찾기등록 성공!" : " 즐겨찾기등록 해제"}");
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: Text('아니요'),
                                                              onPressed: () {
                                                                Navigator.pop(context, "아니요");
                                                                // 즐겨찾기 해제취소 동작 입력

                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  // 북마크 등록인 경우 따로 묻지 않고 그대로 진행
                                                  }else{
                                                    // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                                                    FavoriteCtr.UpdateBookmarked(
                                                        result[index]['_id'], // ID
                                                        FavoriteCtr.TempMainBookmarkedList[index] // 현재상태
                                                    );
                                                    // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                                                    FavoriteCtr.FrequentlyUpdateFavoriteBookmarkedList(index);
                                                    // 즐겨찾기 등록 안내메세지 토스트(Toast)
                                                    PopToast("${result[index]['bcode']}.${result[index]['국문']}( ${result[index]['영문']}) : ${result[index]['cnum']}장 ${result[index]['vnum']}절${FavoriteCtr.TempMainBookmarkedList[index] == 1? " 즐겨찾기등록 성공!" : " 즐겨찾기등록 해제"}");
                                                  }
                                                }
                                            ),
                                          ],
                                        ),
                                        // 성경구절 뿌리기
                                        WordBreakText("${result[index][FavoriteCtr.FavoriteBibleName]}", style: TextStyle(fontSize: BibleCtr.Textsize, height:BibleCtr.Textheight, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),

                          ],
                        );
                    }
                        // 각각을 컨테이너로 묶어서 보여주기

                  ),

                ),
              ),
            );
          }
      );
  }
}
