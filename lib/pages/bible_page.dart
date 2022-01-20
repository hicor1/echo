import 'package:echo/screens/bible_booklist_screen.dart';
import 'package:echo/screens/bible_freesearch_screen.dart';
import 'package:echo/screens/bible_verselist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:echo/controllers/bible_controller.dart';
import 'package:echo/components/bible_widget.dart';
import 'package:echo/components/commom_widget.dart';

// 이건딱정하자
//1. 성경(bible) = GAE, NIV 등
//2. 권(book) = 창세기 / 출애굽기 등등
//3. 장(chapter), 절(verse), 내용(content)

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

class BiblePage extends StatefulWidget {
  const BiblePage({Key? key}) : super(key: key);

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {

  @override
  //(초기화) 페이지 로딩과 동시에 초기화 진행
  void initState() {
    super.initState();
    BibleCtr.GetBibleSearchResult();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // 플로팅 버튼 위젯 불러오기 ( 페이지 전환 때 스크롤 컨트롤을 위해 컨트롤러를 할당해준다 )
      floatingActionButton: FloatingButton(),
      appBar: PreferredSize( // Appbar사이즈를 자유롭게 조절하기 위함
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          centerTitle: true,
          title: Container(
            width: 270,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    BibleCtr.BookListChangeTabIndex(0); // 탭 초기화
                    Get.to(() => BibleBookListPage()); // 페이지 이동
                    },
                  child: Obx(()=> Text("${BibleCtr.BookName}", style: TextStyle(fontSize: 20)))),
                VerticalDivider(color: Colors.white.withOpacity(0.3), thickness: 2.2,indent: 7, endIndent: 7),
                TextButton(
                  onPressed: () {
                    BibleCtr.VerseListChangeTabIndex(0); // 탭 초기화
                    Get.to(() => BibleVerseListPage());// 페이지 이동
                    },
                    child:
                    GetBuilder<BibleController>(
                      builder: (_)=>Text("${BibleCtr.ChapterNo.toString()} 장 ${BibleCtr.VerseNo.toString()}절", style: TextStyle(fontSize: 20)),
                    )
    ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent, // 투명색
          elevation: 0.0, // 그림자 농도 설정 0으로 제거
          leading: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: IconButton(
                onPressed: (){Get.to(()=>BibleFreeSearchScreen());},
                icon: Icon(Icons.manage_search, color: Colors.white,size: 45,),)),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: IconButton(
                onPressed: (){
                  // 글씨크기조정 팝업 띄우기
                  openPopup(context);
                  },
                icon: Icon(Icons.format_size, size: 45.0, ),
              ),
            ),
          ],
          bottom: PreferredSize(
              child: TimerWidget(),
              preferredSize: Size.fromHeight(1.0)
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Divider(color: Colors.white, thickness: 0.2,indent: 10, endIndent: 10),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 35,),
                        Text(" 매일 성경", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BibleViewNumber(), // 한번에 볼 성경 갯수
                        SizedBox(width: 5),
                        MainDropdownBibles(), // 성경 선택 드롭박스
                      ],
                    )
                  ],
                )),
            // 성경구절 결과 리턴 ( 스크롤 컨트롤러도 할당해준다 )
            GetBuilder<BibleController>(
              builder: (_) => BibleCtr.SelectedStyle == "구분" ? MainBibleSearchResult() : MainBibleSearchResult2()
              ),
          ],
        ),
      ),
      );
  }
}
