import 'package:echo/repository/bible_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {


  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "SharedPrefs" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//

  Future<void> SavePrefsData() async {
    //1. 객체 불러오기
    final prefs = await SharedPreferences.getInstance();
    //2. 상태값 저장할 목록 및 저장 수행
    prefs.setString('FavoriteBibleName',      FavoriteBibleName);
    prefs.setStringList('DropdownFilterList', DropdownFilterList);
  }

  // shared preferences 불러오기
  Future<void> LoadPrefsData() async {
    //1. 객체 불러오기
    final prefs = await SharedPreferences.getInstance();
    //2. 불러올 상태값 목록 및 데이터 업데이트
    FavoriteBibleName     = prefs.getString('FavoriteBibleName')!;//(prefs.getString('BibleName') ?? '개역개정');
    DropdownFilterList    = prefs.getStringList('DropdownFilterList')!;//(prefs.getString('BibleName') ?? '개역개정');
    print("불러오기 완료");
  }

  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "favorite_page" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var FavoriteList = [];  // 즐겨찾기 데이터 보관
  var FavoriteBibleName    = "개역개정"; // 보여줄 성경 종류
  var DropdownFilterList = ["날짜 오름차순","날짜 내림차순"]; // 드랍다운 메뉴 리스트
  var SelectedFilter = "날짜 오름차순";
  var SelectedFilter_trans = "verses.bookmark_updated_at asc"; //필터조건 SQL문으로 변환

  var TempMainBookmarkedList = []; // 즐겨찾기 임시 보관공간


  //<함수> 즐겨찾기 리스트 가져오기
  Future<void> GetBibleSearchResult() async {
    //1. 필터조건 SQL문으로 변환

    switch(SelectedFilter){
      case "날짜 내림차순" : SelectedFilter_trans = "verses.bookmark_updated_at asc"; break;
      case "날짜 오름차순" : SelectedFilter_trans = "verses.bookmark_updated_at desc"; break;
      case "성경 내림차순" : SelectedFilter_trans = "verses._id asc"; break;
      case "성경 오름차순" : SelectedFilter_trans = "verses._id desc"; break;
    }

    //2. 즐겨찾기 리스트 가져오기
    FavoriteList = await BibleRepository.GetBookmarkedList(FavoriteBibleName, SelectedFilter_trans);
    //3. 검새결과 새로고침할때마다 (임시)즐겨찾기 리스트 업데이트
    InitUpdateFavoriteBookmarkedList();
    update();
  }

  //<함수> 드랍다운 메뉴에서 선택한 이름 업데이트 ( Not Reactive )
  void FavoriteUpdateSelectedDropdownValue(newvalue) {
    FavoriteBibleName = newvalue; // 바뀐 성경이름으로 업뎃
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    SavePrefsData(); // 설정값 저장
    update();
  }

  //<함수> 드랍다운 메뉴에서 선택한 필터 업데이트 ( Not Reactive )
  void FavoriteUpdateSelectedDropdownFilter(newvalue) {
    SelectedFilter = newvalue; // 바뀐 성경이름으로 업뎃
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    SavePrefsData(); // 설정값 저장
    update();
  }


  // <함수>(초기)즐겨찾기만 따로 상태관리해서 실시간으로 업뎃되도록 해보자 !!
  void InitUpdateFavoriteBookmarkedList(){
    TempMainBookmarkedList = [];  // 배열 초기화 ( 계속쌓이는거 방지 )
    for (var i = 0; i < FavoriteList.length; i++){
      TempMainBookmarkedList.add(FavoriteList[i]['bookmarked']);
    }
  }
  // <함수>(수시)버튼을 누를때마다 해당 인덱스 즐겨찾기만 업뎃해주자 ㄱㄱ
  void FrequentlyUpdateFavoriteBookmarkedList(index){
    //초기값 저장
    var init = TempMainBookmarkedList[index];
    //초기값과 반대로 저장해줘야하므로 조건문으로 확인해서 변경해준다.
    if(init==0){
      TempMainBookmarkedList[index] = 1;
    }else{
      TempMainBookmarkedList[index] = 0;
    }
    update();
  }


  //<함수> 즐겨찾기 업데이트하기
  Future<void> UpdateBookmarked(id, CurrentStatus) async {
    //지역변수 할당
    int bookmarked;
    //상태변환 ( 0->1, 1->0 )
    if (CurrentStatus==0){
      bookmarked = 1;
    }else{
      bookmarked = 0;
    }
    // DB에 덮어쓰기
    await BibleRepository().UpdateBookmarked(id, bookmarked);
    //GetBibleSearchResult();
    update();
  }


}