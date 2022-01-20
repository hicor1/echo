import 'package:echo/controllers/bible_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:echo/repository/bible_repository.dart';

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

//메인 위젯 시작
class BibleVerseListPage extends StatefulWidget {
  const BibleVerseListPage({Key? key}) : super(key: key);

  @override
  _BiblePartListPageState createState() => _BiblePartListPageState();
}

class _BiblePartListPageState extends State<BibleVerseListPage> {


  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    BibleCtr.GetChapterList();
    BibleCtr.GetVerseList();
  }

  //(메인 위젯)
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(BibleCtr.BookName.value, style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            onTap: BibleCtr.VerseListChangeTabIndex,
            indicatorColor: Colors.white,
            //isScrollable: true,
            tabs: [
              Tab(child: Text("장(chapter)", style: TextStyle(fontSize: 20, color: Colors.white))),
              Tab(child: Text("절(verse)", style: TextStyle(fontSize: 20, color: Colors.white)))
            ],
          ),
        ),
        body: Center(
          child:
            GetBuilder<BibleController>(
              builder: (controller){
                return BibleList(BibleCtr.VerseList_selectedPageIndex);
              },
            )
          //
          //child: Text("!!"),
        ),
      ),
      //backgroundColor: Colors.white,
    );
  }



  Widget BibleList(int index) {

    // 선택된 탭 상황에 따른 케이스문
    var Newlist;
    var TargetColumn;
    var endword;
    var _selectedvalue; // 현재 선택된 장 또는 절 번호
    switch (index) {
      case 0:
        Newlist = BibleCtr.ChapterList;  // 장<chapter>을 선택한 경우, 그대로 사용
        TargetColumn = 'cnum';
        endword = '장';
        _selectedvalue = BibleCtr.ChapterNo;
        break;
      case 1:
        Newlist = BibleCtr.VerseList;  // 절<verse>을 선택한 경우, 해당 장<chapter>에 맞는 절 반환
        TargetColumn = 'vnum';
        endword = '절';
        _selectedvalue = BibleCtr.VerseNo;
        break;
    }

    return BibleCtr.ChapterList_isLoading.value // (리턴) 위젯으로 이쁘게 만들어서 보여주기
        ? const Center(child: CircularProgressIndicator())  // (추가)비동기화 호출이므로 로딩 화면 보여주기 기능 넣어줌 ㄱㄱ
        : Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: Column(
        children: [
          Container(
            height: 40,
            color: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${BibleCtr.ChapterNo} 장", style: TextStyle(fontSize: 30, color: Colors.white),),
                  VerticalDivider(color: Colors.white, width: 20, thickness: 0.2, indent: 15,),
                  Text("${BibleCtr.VerseNo} 절", style: TextStyle(fontSize: 30, color: Colors.white),),
                ]
            ),
          ),
          Divider(color: Colors.white, height: 20, thickness: 0.3, endIndent: 50,indent: 50,),
          SizedBox(height: 15),
          Flexible(
            child: Scrollbar(
              child: GridView.builder(
                addAutomaticKeepAlives: true,
                itemCount: Newlist.length,
                itemBuilder: (context, index) => CircleAvatar(
                  // 선택된 항목에 대한 색변경 이벤트
                  backgroundColor: index+1 == _selectedvalue ? Colors.blueAccent : Colors.transparent,
                  child: TextButton(
                      child: Text(
                        "${Newlist[index][TargetColumn]} $endword",
                        style: TextStyle(
                            fontSize: 20,
                            // 선택한 항목에 대한 색변경 이벤트
                            color: index+1 == _selectedvalue ? Colors.white : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        //1. 장(chapter)페이지 인 경우,
                        if(BibleCtr.VerseList_selectedPageIndex==0){
                          BibleCtr.onChapterClicked(Newlist[index][TargetColumn]); // 현재 챕터값 저장 및 벌스값 업뎃
                          DefaultTabController.of(context)!.animateTo(1);//원하는 탭으로 이동
                          //2. 절(verse)페이지 인 경우,
                        }else{
                          BibleCtr.onVerseClicked(Newlist[index][TargetColumn]);// 현재 벌스값 저장
                          Get.back();
                        }
                      }
                  ),
                ),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1.5, //item 의 가로 1, 세로 2 의 비율
                  mainAxisSpacing: 1, //수평 Padding
                  crossAxisSpacing: 10, //수직 Padding
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


