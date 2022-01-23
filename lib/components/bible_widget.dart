import 'package:date_format/date_format.dart';
import 'package:echo/components/commom_widget.dart';
import 'package:echo/components/general.dart';
import 'package:echo/controllers/bible_controller.dart';
import 'package:echo/screens/bible_freesearch_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:word_break_text/word_break_text.dart';


// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

// 메인에서 성경(bibles)선택 드랍다운 위젯 !!!! 아래 자유검색 위젯과 헷갈리면 삿됨!!!!!!
class MainDropdownBibles extends StatelessWidget {
  const MainDropdownBibles({Key? key}) : super(key: key);

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
            GetBuilder<BibleController>(
              builder: (controller){
                return
                  DropdownButton<String>(
                    value: BibleCtr.BibleName,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30, //this inicrease the size
                    elevation: 2,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      BibleCtr.MainUpdateSelectedDropdownValue(newValue);
                    },
                    items: BibleCtr.DropdownValueList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_add_rounded),
                            Text("   $value", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: value == BibleCtr.BibleName ? FontWeight.w900 : FontWeight.w300),),
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


// 한번에 볼 성경갯수 선택 드롭박스 위젯
class BibleViewNumber extends StatelessWidget {
  const BibleViewNumber({Key? key}) : super(key: key);

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
            GetBuilder<BibleController>(
              builder: (controller){
                return
                  DropdownButton<String>(
                    value: BibleCtr.SelectedBibleViewNumber,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30, //this inicrease the size
                    elevation: 2,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      BibleCtr.MainUpdateSelectedBibleViewNumber(newValue);
                    },
                    items: ["1","2","4","6","8","10","20"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.format_list_numbered_rtl_sharp),
                            Text("   $value", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: value == BibleCtr.SelectedBibleViewNumber ? FontWeight.w900 : FontWeight.w300),),
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

// 메인에서 성경구절 검색 결과 표시 위젯 ( 완전 구분 스타일 ) (1/2)
class MainBibleSearchResult extends StatefulWidget {
  const MainBibleSearchResult({Key? key}) : super(key: key);

  @override
  _MainBibleSearchResultState createState() => _MainBibleSearchResultState();
}

class _MainBibleSearchResultState extends State<MainBibleSearchResult> {

  @override
  Widget build(BuildContext context) {
    //_scrollController.jumpTo(0);
    return Flexible(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
          child: Scrollbar(
            controller: BibleCtr.scrollController,
            thickness: 3,   //스크롤바의 두께를 지정한다
            child: ListView.builder(
                controller: BibleCtr.scrollController,   //ScrollBar에 컨트롤러를 알려준다
                itemCount: BibleCtr.BibleSearchResult.length,
                itemBuilder: (context, index) =>
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.5,),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${BibleCtr.BibleSearchResult[index]['bcode']}."
                                  "${BibleCtr.BibleSearchResult[index]['국문']}("
                                  "${BibleCtr.BibleSearchResult[index]['영문']}) : "
                                  "${BibleCtr.BibleSearchResult[index]['cnum']}장 "
                                "${BibleCtr.BibleSearchResult[index]['vnum']}절 ",
                                style: TextStyle(color: Colors.grey, fontSize: BibleCtr.Textsize*0.2+10),),
                              // 즐겨찾기 버튼 위젯
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero, // 아이콘 패딩 없애기
                                  constraints: BoxConstraints(), // 아이콘 패딩 없애기
                                  icon : BibleCtr.TempMainBookmarkedList[index] == 1? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                                  color: BibleCtr.TempMainBookmarkedList[index]== 1? Colors.red : Colors.grey,
                                  onPressed: (){
                                    // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                                    BibleCtr.FrequentlyUpdateTempMainBookmarkedList(index);
                                    // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                                    BibleCtr.UpdateBookmarked(
                                        BibleCtr.BibleSearchResult[index]['_id'], // ID
                                        BibleCtr.BibleSearchResult[index]['bookmarked'] // 현재상태
                                    );
                                    // 즐겨찾기 등록 안내메세지 토스트(Toast)
                                    PopToast(
                                        "${BibleCtr.BibleSearchResult[index]['bcode']}."
                                            "${BibleCtr.BibleSearchResult[index]['국문']}("
                                            "${BibleCtr.BibleSearchResult[index]['영문']}) : "
                                            "${BibleCtr.BibleSearchResult[index]['cnum']}장 "
                                            "${BibleCtr.BibleSearchResult[index]['vnum']}절"
                                            "${BibleCtr.TempMainBookmarkedList[index] == 1? " 즐겨찾기등록 성공!" : " 즐겨찾기등록 해제"}"
                                    );
                                  }
                              ),
                            ],
                          ),
                          WordBreakText("${BibleCtr.BibleSearchResult[index][BibleCtr.BibleName]}",
                            style: TextStyle(
                                color: BibleCtr.TempMainBookmarkedList[index] == 1? Colors.lightGreen : Colors.white,
                                fontSize: BibleCtr.Textsize,
                                height: BibleCtr.Textheight),),
                        ],
                      ),
                    )
            ),
          ),
        )
    );
  }
}

// 메인에서 성경구절 검색 결과 표시 위젯 ( 연속 스타일 ) (2/2)
class MainBibleSearchResult2 extends StatefulWidget {
  const MainBibleSearchResult2({Key? key}) : super(key: key);

  @override
  _MainBibleSearchResult2State createState() => _MainBibleSearchResult2State();
}

class _MainBibleSearchResult2State extends State<MainBibleSearchResult2> {

  @override
  Widget build(BuildContext context) {
    //_scrollController.jumpTo(0);
    return Flexible(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Scrollbar(
            controller: BibleCtr.scrollController,
            thickness: 3,   //스크롤바의 두께를 지정한다
            child: ListView.builder(
                controller: BibleCtr.scrollController,   //ScrollBar에 컨트롤러를 알려준다
                itemCount: BibleCtr.BibleSearchResult.length,
                itemBuilder: (context, index) =>
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${BibleCtr.BibleSearchResult[index]['vnum']}",
                          style: TextStyle(
                              fontSize: BibleCtr.Textsize*0.2+10,
                              color: Colors.grey.withOpacity(0.6),
                              height: BibleCtr.Textheight),),
                        Flexible(
                          // 텍스트박스 클릭이벤트 추가
                          child: InkWell(
                            // 클릭하면 즐찾추가 안내 팝업 등장 ㄱㄱ
                            onTap: (){
                              // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                              BibleCtr.FrequentlyUpdateTempMainBookmarkedList(index);
                              // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                              BibleCtr.UpdateBookmarked(
                                  BibleCtr.BibleSearchResult[index]['_id'], // ID
                                  BibleCtr.BibleSearchResult[index]['bookmarked'] // 현재상태
                              );
                              // 즐겨찾기 등록 안내메세지 토스트(Toast)
                              PopToast(
                                  "${BibleCtr.BibleSearchResult[index]['bcode']}."
                                      "${BibleCtr.BibleSearchResult[index]['국문']}( "
                                      "${BibleCtr.BibleSearchResult[index]['영문']}) : "
                                      "${BibleCtr.BibleSearchResult[index]['cnum']}장 "
                                      "${BibleCtr.BibleSearchResult[index]['vnum']}절"
                                      "${BibleCtr.TempMainBookmarkedList[index] == 1? " 즐겨찾기등록 성공!" : " 즐겨찾기등록 해제"}"
                              );
                            },
                            child: WordBreakText("${BibleCtr.BibleSearchResult[index][BibleCtr.BibleName]}",
                              style: TextStyle(
                                  color: BibleCtr.TempMainBookmarkedList[index] == 1? Colors.lightGreen : Colors.white,
                                  fontSize: BibleCtr.Textsize,
                                  height: BibleCtr.Textheight),),
                          ),
                        ),
                      ],
                    )
            ),
          ),
        )
    );
  }
}



// 자유검색에서 성경(bibles)선택 드랍다운 위젯
class DropdownBibles extends StatelessWidget {
  const DropdownBibles({Key? key}) : super(key: key);

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
            GetBuilder<BibleController>(
              builder: (controller){
                return
                  DropdownButton<String>(
                    value: BibleCtr.SelectedDropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30, //this inicrease the size
                    elevation: 2,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (newValue) async {
                      BibleCtr.UpdateSelectedDropdownValue(newValue);
                    },
                    items: BibleCtr.DropdownValueList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_add_rounded),
                            Text("   $value", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: value == BibleCtr.SelectedDropdownValue ? FontWeight.w900 : FontWeight.w300),),
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

// 시간표시 위젯
class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: TimerBuilder.periodic(
        const Duration(seconds: 1),
        builder: (context) {
          return Text(
            formatDate(DateTime.now(), [yy,'.',mm,'.',dd,' ',am,' ',hh, ':', nn]),
            style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w400,
                color: Colors.white
            ),
          );
        },
      ),
    );;
  }
}


// 자유검색결과표시 위젯
class FreeSearchResult extends StatefulWidget {
  const FreeSearchResult({Key? key, required this.textcontroller}) : super(key: key);

  final textcontroller; // 텍스트 컨트롤러를 받아와야 강조표기할수있음!!

  @override
  _FreeSearchResultState createState() => _FreeSearchResultState();
}

class _FreeSearchResultState extends State<FreeSearchResult> {

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(3,5,3,30),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: BibleCtr.FressSearchList.length,
            itemBuilder: (context, index) {
              // 변수 정의
              var result = BibleCtr.FressSearchList;

              // 아래부터 진짜 위젯 뿌리기
              return InkWell(
                splashColor: Colors.lightBlueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                highlightColor: Colors.lightBlueAccent.withOpacity(0.1),
                // 컨테이너를 클릭 했을 때,
                onTap: () {
                  //문의창 띄우기 ( 진짜 해당구절로 이동하는게 맞는지 문의 )
                  IsMoveDialog(context, result, index, false);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2.5,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${result[index]['bcode']}."
                              "${result[index]['국문']}("
                              "${result[index]['영문']}) : "
                              "${result[index]['cnum']}장 "
                              "${result[index]['vnum']}절",
                            style: TextStyle(color: Colors.grey, fontSize: 18),),
                          // 즐겨찾기 버튼 위젯
                          IconButton(
                              iconSize: 25,
                              padding: EdgeInsets.zero, // 아이콘 패딩 없애기
                              constraints: BoxConstraints(), // 아이콘 패딩 없애기
                              icon : BibleCtr.TempBookmarkedList[index] == 1? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                              color: BibleCtr.TempBookmarkedList[index]== 1? Colors.red : Colors.grey,
                              onPressed: (){
                                // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                                BibleCtr.FrequentlyUpdateTempBookmarkedList(index);
                                // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                                BibleCtr.UpdateBookmarked(
                                    BibleCtr.FressSearchList[index]['_id'], // ID
                                    BibleCtr.FressSearchList[index]['bookmarked'] // 현재상태
                                );
                                // 즐겨찾기 등록 안내메세지 토스트(Toast)
                                PopToast(
                                    "${BibleCtr.FressSearchList[index]['bcode']}."
                                        "${BibleCtr.FressSearchList[index]['국문']}("
                                        "${BibleCtr.FressSearchList[index]['영문']}) : "
                                        "${BibleCtr.FressSearchList[index]['cnum']}장 "
                                        "${BibleCtr.FressSearchList[index]['vnum']}절"
                                        "${BibleCtr.TempBookmarkedList[index] == 1? " 즐겨찾기등록 성공!" : " 즐겨찾기등록 해제"}"
                                );
                              }
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      SubstringHighlight(
                        text : BibleCtr.FressSearchList[index][BibleCtr.SelectedDropdownValue],
                        term: this.widget.textcontroller.text,
                        textStyle: TextStyle(color:Colors.white, fontSize: 23),
                        textStyleHighlight: TextStyle(              // highlight style
                          color: Colors.lightBlueAccent,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // 각각의 컨테이너를 눌렀을때 이벤트 부여

          ),
        ),
      ),
    );;
  }
}

// 성경검색결과표시 위젯
class BibleSearchResult extends StatefulWidget {
  const BibleSearchResult({Key? key}) : super(key: key);


  @override
  _BibleSearchResultState createState() => _BibleSearchResultState();
}

class _BibleSearchResultState extends State<BibleSearchResult> {

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.fromLTRB(3,5,3,30),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: BibleCtr.FressSearchList.length,
            itemBuilder: (context, index) =>
            // 각각의 컨테이너를 눌렀을때 이벤트 부여
            InkWell(
              splashColor: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(50),
              highlightColor: Colors.lightBlueAccent.withOpacity(0.4),
              // 컨테이너를 클릭 했을 때,
              onTap: () {
                // 토스트메세지 띄우기
                PopToast('해당 구절로 이동합니다.');
                // 선택정보 업데이트
                ////// 이부분 구현해야됨!!! //////

                // 이전페이지로 돌아가기
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2.5,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${BibleCtr.FressSearchList[index]['bcode']}."
                            "${BibleCtr.FressSearchList[index]['국문']}( "
                            "${BibleCtr.FressSearchList[index]['영문']}) : "
                            "${BibleCtr.FressSearchList[index]['cnum']}장 "
                            "${BibleCtr.FressSearchList[index]['vnum']}절",
                          style: TextStyle(color: Colors.grey, fontSize: 18),),
                        // 즐겨찾기 버튼 위젯
                        IconButton(
                            iconSize: 30,
                            padding: EdgeInsets.zero, // 아이콘 패딩 없애기
                            constraints: BoxConstraints(), // 아이콘 패딩 없애기
                            icon : BibleCtr.TempBookmarkedList[index] == 1? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                            color: BibleCtr.TempBookmarkedList[index]== 1? Colors.red : Colors.grey,
                            onPressed: (){
                              // 즐겨찾기 임시보관리스트 업데이트 ( UI 반응형 업뎃을 위함 )
                              BibleCtr.FrequentlyUpdateTempBookmarkedList(index);
                              // 즐겨찾기 버튼 누르면, 즐겨찾기 DB  업뎃 ( 실제 DB에 기록하는 부분 )
                              BibleCtr.UpdateBookmarked(
                                  BibleCtr.FressSearchList[index]['_id'], // ID
                                  BibleCtr.FressSearchList[index]['bookmarked'] // 현재상태
                              );
                              // 즐겨찾기 등록 안내메세지 토스트(Toast)
                              PopToast(
                                  "${BibleCtr.FressSearchList[index]['bcode']}."
                                      "${BibleCtr.FressSearchList[index]['국문']}( "
                                      "${BibleCtr.FressSearchList[index]['영문']}) : "
                                      "${BibleCtr.FressSearchList[index]['cnum']}장 "
                                      "${BibleCtr.FressSearchList[index]['vnum']}절"
                                      "${BibleCtr.TempBookmarkedList[index] == 1? " 즐겨찾기등록성공!" : " 즐겨찾기해제!"}"
                              );
                            }
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SubstringHighlight(
                      text : BibleCtr.FressSearchList[index][BibleCtr.SelectedDropdownValue],
                      term: "",
                      textStyle: TextStyle(color:Colors.white, fontSize: 23),
                      textStyleHighlight: TextStyle(              // highlight style
                        color: Colors.lightBlueAccent,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );;
  }
}

// 양쪽으로 띄우는 플로팅 버튼 ( https://www.kindacode.com/article/how-to-add-multiple-floating-buttons-in-flutter/)
class FloatingButton extends StatefulWidget {
  const FloatingButton({Key? key}) : super(key: key);

  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 20,
          bottom: 0.0,
          child: Container(
            width: 75,
            height: 55,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              splashColor: Colors.white.withOpacity(0.25),
              heroTag: 'back',
              // 뒤로가기 버튼을 눌렀을 때, 뒤에 자료가 존재하는지 확인해서 업데이트한다.
              onPressed: () {
                // 페이지 조회
                var StartId = BibleCtr.id - int.parse(BibleCtr.SelectedBibleViewNumber);
                if(StartId>=1){
                  BibleCtr.ClikFloatingButton(StartId);
                }else{
                  PopToast("첫페이지 입니다.");
                }
              },
              child: Icon(Icons.keyboard_arrow_left, size: 55, color: Colors.white.withOpacity(0.5),),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
                side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 2)
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0.0,
          child: Container(
            width: 75,
            height: 55,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              splashColor: Colors.white.withOpacity(0.25),
              heroTag: 'next',
              onPressed: () {
                // 페이지 조회
                var StartId = BibleCtr.id + int.parse(BibleCtr.SelectedBibleViewNumber);
                if(StartId<=31102){ // 총 31102개의 절로 이루어져있으므로,
                  BibleCtr.ClikFloatingButton(StartId);
                }else{
                  PopToast("마지막페이지 입니다.");
                }
              },
              child: Icon(Icons.keyboard_arrow_right, size: 55, color: Colors.white.withOpacity(0.5),),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
                side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 2)
              ),
            ),
          ),
        ),
        // Add more floating buttons if you want
        // There is no limit
      ],
    );
  }
}

