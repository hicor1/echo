import 'package:echo/controllers/bible_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


// Gex컨트롤러 객체 초기화
final BibleCtr = Get.put(BibleController());

// 본 클래스 시작
class OtherController extends GetxController {

  var selectedPageIndex = 0; // 현재 선택된 페이지 인덱스 저장

  //<함수> 현재 페이지 변경 함수
  void PageChanged(index){
    selectedPageIndex = index;
    BibleCtr.SavePrefsData(); //상태값 저장
    update();
  }
}