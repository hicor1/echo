
import 'package:echo/controllers/bible_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:echo/components/general.dart';
import 'package:echo/components/bible_widget.dart';


// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

class BibleFreeSearchScreen extends StatefulWidget {
  const BibleFreeSearchScreen({Key? key}) : super(key: key);

  @override
  _BibleFreeSearchScreenState createState() => _BibleFreeSearchScreenState();
}

class _BibleFreeSearchScreenState extends State<BibleFreeSearchScreen> {
  TextEditingController textController = TextEditingController();


  @override
  // (메인위젯)
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("성경 검색", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey.withOpacity(0.7),
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("1. 성경선택     : ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    // 드롭다운 위젯 불러오기
                    DropdownBibles(),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                height: 40,
                child: Row(
                  children: [
                    Text("2. 검색어입력 : ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Flexible(
                      child: TextField(
                        // 키패드에서 "완료"버튼 누르면 이벤트 발동
                        onEditingComplete: (){
                          // 최소 검색글자수 ( 2글자 ) 만족하는지 체크
                          if(textController.text.length>=2){
                            BibleCtr.GetFreeSearchList(textController.text);
                            // 키패드 감추기
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            currentFocus.unfocus();
                          }else{
                            FlutterDialog(context);
                          }
                        },
                        controller: textController, // 텍스트값을 가져오기 위해 컨트롤러 할당
                        maxLines: 1, // 줄바꿈 못하게, 화면 깨짐
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                        //focusNode: _focus,
                        autofocus: false, // 바로 검색창 띄워주기
                        keyboardType: TextInputType.text,
                        //onChanged: (text){BibleCtr.UpdateSearchText(text);},// 글자쓸때마다 이벤트 발생
                        decoration: InputDecoration(
                          hintText: "검색어를 입력해주세요",
                          hintStyle: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: IconButton(
                          // 돋보기 버튼 누르면 이벤트 발동
                          onPressed: (){
                            // 최소 검색글자수 ( 2글자 ) 만족하는지 체크
                            if(textController.text.length>=2){
                              BibleCtr.GetFreeSearchList(textController.text);
                              // 키패드 감추기
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              currentFocus.unfocus();
                            }else{
                              FlutterDialog(context);
                            }
                          },
                          icon: Icon(Icons.search, size:25, color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              // 검색결과 텍스트
              GetBuilder<BibleController>(
                builder: (_)=>Text('"${textController.text}" 에 대한 검색결과가 ${BibleCtr.FressSearchList.length}건 있습니다.', style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Divider(color: Colors.white, height: 20, thickness: 1.0, endIndent: 0,indent: 0,),
              // 결과표시 위젯 ( 텍스트 강조표시를 위해 텍스트 컨트롤러도 같이 보내줘야함!!)
              GetBuilder<BibleController>(
                builder: (_)=>FreeSearchResult(textcontroller: textController),
              )
            ],
          ),
        ),
      ),
    );
  }
}
