import 'package:echo/controllers/bible_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'general.dart';

// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

//// 검색창 위젯 ////
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  // 검색창 텍스트에디터 컨트롤러 생성
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white, size: 50),
          Flexible(
            child: Container(
              //width: 300,
              height: 55,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextField(
                // 키패드에서 "완료"버튼 누르면 이벤트 발동
                onEditingComplete: () {
                  if (textController.text.length >= 2) {
                    BibleCtr.GetFreeSearchList(textController.text);
                    // 검색어 입력 완료 후 키패드 감추기
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();
                  } else {
                    FlutterDialog(context);
                  }
                },
                controller: textController,
                // 텍스트값을 가져오기 위해 컨트롤러 할당
                maxLines: 1,
                // 줄바꿈 못하게, 화면 깨짐
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                //focusNode: _focus,
                autofocus: false,
                // 바로 검색창 띄워주기
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  // 글자쓸때마다 이벤트 발생
                  if (text.length >= 0) {
                    BibleCtr.BibleSearch(text);
                  } else {
                    null;
                  }
                },
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(1.0),
                  filled: true,
                  hintText: "검색어를 입력해주세요",
                  hintStyle: TextStyle(
                      fontSize: 23.0, color: Colors.grey.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 글씨 크기 조정용 안내창띄우기
void openPopup(context) {
  Alert(
      context: context,
      // 팝업창 스타일 조정
      style: AlertStyle(
          titleStyle: TextStyle(fontSize: 0, fontWeight: FontWeight.bold),
          animationDuration: Duration(milliseconds: 200),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.grey, width: 3),
          ),
      ),
      title: "",
      content: GetBuilder<BibleController>(
        builder: (_) => Column(
          children: <Widget>[
            //1. 글씨크기
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("글씨 크기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 3),)
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    padding: EdgeInsets.all(10),
                    //height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("가나다abcABC", style: TextStyle(fontSize:BibleCtr.Textsize),),
                        Container(
                          width: 400,
                          child: SfSlider(
                            min: 10.0,
                            max: 50.0,
                            interval: 10,
                            stepSize: 2,
                            showTicks: false,
                            minorTicksPerInterval: 1,
                            showLabels: true,
                            enableTooltip: true,
                            tooltipShape: SfPaddleTooltipShape(),
                            value: BibleCtr.Textsize,
                            onChanged: (dynamic newValue) {
                              BibleCtr.TextSizeChanged(newValue);
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            //2. 줄 간격
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("줄 간격", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 3),)
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.all(10),
                      //height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("가나다abcABC", style: TextStyle(fontSize:20),),
                          Text("가나다abcABC", style: TextStyle(fontSize:20, height:BibleCtr.Textheight),),
                          Container(
                            width: 400,
                            child: SfSlider(
                              min: 1.0,
                              max: 3.0,
                              interval: 1,
                              stepSize: 0.2,
                              showTicks: false,
                              minorTicksPerInterval: 1,
                              showLabels: true,
                              enableTooltip: true,
                              tooltipShape: SfPaddleTooltipShape(),
                              value: BibleCtr.Textheight,
                              onChanged: (dynamic newValue) {
                                BibleCtr.TextHeightChanged(newValue);
                              },
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            //3. 스타일
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("스타일", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 3),)
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.all(10),
                      //height: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text("줄글"),
                              Icon(Icons.align_horizontal_left, size: 30),
                              Radio(value: "줄글", groupValue: BibleCtr.SelectedStyle,
                                  onChanged: (value){BibleCtr.TextStyleChanged("줄글");})
                            ],
                          ),
                          Column(
                            children: [
                              Text("구분"),
                              Icon(Icons.crop_square_rounded, size: 30),
                              Radio(value: "구분", groupValue: BibleCtr.SelectedStyle,
                                  onChanged: (value){BibleCtr.TextStyleChanged("구분");})
                            ],
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            //상태값 저장
            BibleCtr.SavePrefsData();
            //이전화면으로 돌아가기
            Navigator.pop(context);},
          child: Text(
            "확인",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

