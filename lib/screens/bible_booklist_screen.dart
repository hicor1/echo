import 'package:echo/components/commom_widget.dart';
import 'package:echo/components/general.dart';
import 'package:echo/controllers/bible_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

class BibleBookListPage extends StatefulWidget {
  const BibleBookListPage({Key? key}) : super(key: key);

  @override
  _BibleListPageState createState() => _BibleListPageState();
}

class _BibleListPageState extends State<BibleBookListPage> {
  // 검색창 텍스트에디터 컨트롤러 생성
  TextEditingController textController = TextEditingController();

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    BibleCtr.GetBookList(); // 처음한번 성서 리스트 가져오기
  }

  //(위젯)
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "성서",
            style: TextStyle(fontSize: 25),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            onTap: BibleCtr.BookListChangeTabIndex,
            indicatorColor: Colors.white,
            //isScrollable: true,
            tabs: [
              Tab(text: "전체(66)"),
              Tab(text: "구약(39)"),
              Tab(text: "신약(27)"),
            ],
          ),
        ),

        body: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              //// 검색창 위젯 ////
              GetBuilder<BibleController>(
                builder: (_)=>SearchBarWidget()),
              Divider(color: Colors.white, height: 15, thickness: 0.5, endIndent: 10,indent: 10,),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,0,10,10),
                  child: Scrollbar(
                    child: GetBuilder<BibleController>(
                      builder: (controller){
                        return BibleList(controller.booklist_selectedPageIndex);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //backgroundColor: Colors.white,
    );
  }

  //(위젯) 성경리시트 보여주는 위젯
  Widget BibleList(int index) {
    var Newlist;
    // 탭번호에 따른 리스트 필터링
    switch(index){
      case 0 : Newlist =
          BibleCtr.BookList; break; // "전체"인 경우로, 그대로 보여준다
      case 1 : Newlist =
          BibleCtr.BookList.where((f)=>f['type'] == 'old').toList(); break; // "old"인 경우
      case 2 : Newlist =
          BibleCtr.BookList.where((f)=>f['type'] == 'new').toList(); break; // "new"인 경우
    }

    // (리턴) 위젯으로 이쁘게 만들어서 보여주기
    // (추가)비동기화 호출이므로 로딩 화면 보여주기 기능 넣어줌 ㄱㄱ
    return BibleCtr.BookList_isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: Newlist.length,
      itemBuilder: (context, index) => TextButton(
        onPressed: () {
          BibleCtr.BookSelect(Newlist[index]['국문'], Newlist[index]['bcode']); // 상태저장
          Get.back(); // 이전페이지로 돌아가기
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${Newlist[index]['bcode']}. "
                  "${Newlist[index]['국문']} ("
                  "${Newlist[index]['영문']})"
              ,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Colors.grey,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
