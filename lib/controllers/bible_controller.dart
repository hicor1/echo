import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:echo/repository/bible_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


//bible > book > chapter > verse > content
class BibleController extends GetxController {

  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "SharedPrefs" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var Prefs_isLoading = true.obs; // 성경리스트 불러왔는지 확인

  Future<void> SavePrefsData() async {
    //1. 객체 불러오기
    final prefs = await SharedPreferences.getInstance();
    //2. 상태값 저장할 목록 및 저장 수행
    prefs.setString('BibleName', BibleName);
    prefs.setString('BookName', BookName.value);
    prefs.setInt   ('Bookcode', Bookcode);
    prefs.setInt   ('ChapterNo', ChapterNo);
    prefs.setInt   ('VerseNo', VerseNo);
    prefs.setInt   ('id', id);
    prefs.setDouble('Textsize', Textsize);
    prefs.setDouble('Textheight', Textheight);
    prefs.setString('SelectedStyle', SelectedStyle);
    prefs.setString('SelectedBibleViewNumber', SelectedBibleViewNumber);

  }

  // shared preferences 불러오기
  Future<void> LoadPrefsData() async {

    //1. 객체 불러오기
    final prefs = await SharedPreferences.getInstance();

    //2. 불러올 상태값 목록 및 데이터 업데이트
    // for(var element in prefs.getKeys()){
    //   DataMap[element] = prefs.get(element);
    // }
    BibleName       = prefs.getString('BibleName') == null ? BibleName : prefs.getString('BibleName')!;
    BookName.value  = prefs.getString('BookName') == null ? BookName.value : prefs.getString('BookName')!;
    Bookcode        = prefs.getInt('Bookcode') == null ? Bookcode : prefs.getInt('Bookcode')!;
    ChapterNo       = prefs.getInt('ChapterNo') == null ? ChapterNo : prefs.getInt('ChapterNo')!;
    VerseNo         = prefs.getInt('VerseNo') == null ? VerseNo : prefs.getInt('VerseNo')!;
    id              = prefs.getInt('id') == null ? id : prefs.getInt('id')!;
    Textsize        = prefs.getDouble('Textsize') == null ? Textsize : prefs.getDouble('Textsize')!;
    Textheight      = prefs.getDouble('Textheight') == null ? Textheight : prefs.getDouble('Textheight')!;
    SelectedStyle   = prefs.getString('SelectedStyle') == null ? SelectedStyle : prefs.getString('SelectedStyle')!;
    SelectedBibleViewNumber = prefs.getString('SelectedBibleViewNumber')  == null ? SelectedBibleViewNumber : prefs.getString('SelectedBibleViewNumber')!;
    //3. 로딩상태 업데이트
    Prefs_isLoading.value = false;
    update(); // 상태업데이트 내용이 반영되어 로딩이 끝났음을 알려줘야함 ㄱㄱ

    print("불러오기 완료");
  }

  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "bible_page" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var BibleName   = '개역개정'; // 성경종류 선택
  var BookName    = '창세기'.obs;
  var Bookcode    = 1;
  var ChapterNo   = 1; // '장' 번호
  var VerseNo     = 1; // '절' 번호

  var BibleSearchResult = []; // 성경 검색 결과
  var id                = 1;  // 현재 검색중인 성경구절의 아이디값
  var DropdownValueList = ["개역개정","개역한글판_국문","개역한글판_국한문","쉬운성경","현대어성경","현대인의성경","NIV","KJV","AKJV","UKJV","ASV"].obs; // 드랍다운 메뉴 리스트 // ["개역한글판_국문",	"쉬운성경",	"개역개정",	"현대어성경",	"현대인의성경",	"개역한글판_국한문",	"AKJV",	"ASV",	"KJV",	"UKJV",	"NIV"]
  var SelectedBibleViewNumber = "1";// 한번에 볼 성경구절 갯수
  var TempMainBookmarkedList = []; // 즐겨찾기 임시 보관공간

  final ScrollController scrollController = ScrollController(); // 메인페이지 스크롤 컨트롤러 선언

  var Textsize   = 20.0; // 슬라이더를 이용한 글씨크기 변경값 저장
  var Textheight = 2.0; // 슬라이더를 이용한 글씨높이 변경값 저장
  var SelectedStyle = "줄글"; // 줄글 또는 구분 스타일 방식 저장


  //<함수> 드랍다운 메뉴에서 선택한 이름 업데이트 ( Not Reactive )
  void MainUpdateSelectedDropdownValue(newvalue) {
    BibleName = newvalue; // 바뀐 성경이름으로 업뎃
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    SavePrefsData(); //상태값 저장
    update([BibleSearchResult]);
  }

  //<함수> 한번에 볼 성경갯수 값 업데이트 ( Not Reactive )
  void MainUpdateSelectedBibleViewNumber(newvalue) {
    SelectedBibleViewNumber = newvalue; // 바뀐 성경이름으로 업뎃
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    SavePrefsData(); //상태값 저장
    update([BibleSearchResult]);
  }

  //<함수> 조건에 맞는 성경구절(content) 가져오기
  Future<void> GetBibleSearchResult() async {
    //1. 해당 성경구절(content)의 아이디(_id) 가져오기
    var temp = await BibleRepository.GetContentId(Bookcode, ChapterNo, VerseNo);
    id = temp[0]['_id'];
    //2. 아이디(_id)와 갯수로부터 결과 가져오기
    BibleSearchResult = await BibleRepository.GetContent(id, int.parse(SelectedBibleViewNumber), BibleName);
    // 로딩완료 상태로 전환
    BookList_isLoading.value = false;
    InitUpdateTempMainBookmarkedList(); // 검새결과 새로고침할때마다 (임시)즐겨찾기 리스트 업데이트
    update();
  }

  // <함수>(초기)즐겨찾기만 따로 상태관리해서 실시간으로 업뎃되도록 해보자 !!
  void InitUpdateTempMainBookmarkedList(){
    TempMainBookmarkedList = [];  // 배열 초기화 ( 계속쌓이는거 방지 )
    for (var i = 0; i < BibleSearchResult.length; i++){
      TempMainBookmarkedList.add(BibleSearchResult[i]['bookmarked']);
    }
  }
  // <함수>(수시)버튼을 누를때마다 해당 인덱스 즐겨찾기만 업뎃해주자 ㄱㄱ
  void FrequentlyUpdateTempMainBookmarkedList(index){
    //초기값 저장
    var init = TempMainBookmarkedList[index];
    //초기값과 반대로 저장해줘야하므로 조건문으로 확인해서 변경해준다.
    if(init==0){
      TempMainBookmarkedList[index] = 1;
    }else{
      TempMainBookmarkedList[index] = 0;
    }
    update([TempMainBookmarkedList]);
  }

  // <함수>왼쪽, 오른쪽 넘기기 클릭 함수, Toast위젯까지 보여줘야하므로 widget단에서 시작 id까지 계산해서 넘기자 ㄱㄱ
  Future<void> ClikFloatingButton(int StartId) async {
    //1. 아이디(id)값 업데이트
    id = StartId;
    BibleSearchResult = await BibleRepository.GetContent(StartId, int.parse(SelectedBibleViewNumber), BibleName);//DB검색
    //2. DB결 과로부터  (BookName / Bookcode / ChapterNo / VerseNo)정보 업데이트하기
    BookName.value  = BibleSearchResult[0]['국문'];
    Bookcode  = BibleSearchResult[0]['bcode'];
    ChapterNo = BibleSearchResult[0]['cnum'];
    VerseNo   = BibleSearchResult[0]['vnum'];
    //3. 메인페이지 스크롤 초기화
    scrollController.jumpTo(0.0);
    // 로딩완료 상태로 전환
    BookList_isLoading.value = false;
    InitUpdateTempMainBookmarkedList(); // 검새결과 새로고침할때마다 (임시)즐겨찾기 리스트 업데이트
    SavePrefsData(); //상태값 저장
    update();
  }

  //<모듈> 슬라이더를 이용한 글씨크기 변경 함수
  void TextSizeChanged(newvalue){
    Textsize = newvalue;
    update();
  }
  //<모듈> 슬라이더를 이용한 글씨높이 변경 함수
  void TextHeightChanged(newvalue){
    Textheight = newvalue;
    update();
  }

  //<모듈> 라이도버튼을 이용한 스타일 변경 함수
  void TextStyleChanged(newvalue){
    SelectedStyle = newvalue;
    update();
  }



  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼▼▼▼▼ "bible_booklist_screen" 정리 ▼▼▼▼▼▼▼▼ //
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var BookList    = []; // 성경 담을 공간
  var booklist_selectedPageIndex = 0; // 탭번호 저장 ( 뭔가 잘 안되서 Reactive하게는 못함 )
  var BookList_isLoading = true.obs; // 성경리스트 불러왔는지 확인

  //<함수>탭변경 변경 이벤트 ( Not Reactive )
   BookListChangeTabIndex(index) {
    booklist_selectedPageIndex = index; // 현재 탭번호 저장
    update();
  }

  //<함수>성경(book)리스트 받아오기
  Future<void> GetBookList() async {
    BookList = await BibleRepository.GetBookList();
    BookList_isLoading.value = false; // 로딩완료 상태로 전환
    update();
  }

  //<함수>성경(Book) 선택 이벤트
  Future<void> BookSelect(name, code) async {
    BookName.value  = name; // 성경 이름 업데이트
    Bookcode  = code; // 성경 코드 업데이트
    ChapterNo = 1; // 챕터번호 초기화
    VerseNo   = 1; // 벌스번호 초기화
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    SavePrefsData(); //상태값 저장
    update();
  }

  // <함수>성경이름 자유검색 ( ex: 창세기, 출애굽기 등등 검색 하는 기능 + 국&영문 동시)
  Future<void> BibleSearch(query) async {
     // 최소 1글자 이상일때만 작동하도록 위젯에서 설정해줘야함ㄱㄱ
    BookList = await BibleRepository.BibleSearch(query);
    update();
  }


  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "bible_verselist_screen" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var ChapterList  = []; // 챕터리스트 담을 공간
  var VerseList    = []; // 챕터리스트 담을 공간
  var VerseList_selectedPageIndex = 0; // 탭번호 저장 ( 뭔가 잘 안되서 Reactive하게는 못함 )
  var ChapterList_isLoading = true.obs; // 챕터리스트 불러왔는지 확인
  var VerseList_isLoading = true.obs; // 절(verse)리스트 불러왔는지 확인

  //<함수>탭변경 변경 이벤트 ( Not Reactive )
  VerseListChangeTabIndex(index) {
    VerseList_selectedPageIndex = index; // 현재 탭번호 저장
    // 장(chapter) -> 절(verse)로 탭이동할때 절 리스트 갱신
    update();
  }
  //<함수>장(chapter)번호 클릭 이벤트 ( Not Reactive )
  onChapterClicked(number) {
    ChapterNo = number; // 현재 챕터번호 저장
    VerseList_selectedPageIndex = 1; // 현재 탭번호 업데이트
    GetVerseList(); // 클릭한 챕터 번호에 맞는 절(verse)리스트 업데이트 해주기
    VerseNo = 1; // 챕터번호가 새롭게 매겨지면 절 번호 1번으로 초기화
    update();
  }

  //<함수>장(chapter)리스트 받아오기
  Future<void> GetChapterList() async {
    ChapterList = await BibleRepository.ChapterList(this.Bookcode);
    ChapterList_isLoading.value = false; // 로딩완료 상태로 전환
    update();
  }

  //<함수>절(verse)번호 클릭 이벤트 ( Not Reactive )
  onVerseClicked(number) {
    VerseNo = number; // 현재 탭번호 저장
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    scrollController.jumpTo(0.0);// 메인페이지 스크롤 초기화
    SavePrefsData(); //상태값 저장
    update();
  }

  //<함수>절(verse)리스트 받아오기
  Future<void> GetVerseList() async {
    VerseList = await BibleRepository.VerseList(this.Bookcode, this.ChapterNo);
    VerseList_isLoading.value = false; // 로딩완료 상태로 전환
    update();
  }

  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  //▼▼▼▼ "bible_freesearch_screen" 정리 ▼▼▼▼//
  //▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼//
  var FressSearchList = [].obs;
  var SelectedDropdownValue = "개역개정"; // 드랍다운 메뉴에서 선택한 성경이름
  var TempBookmarkedList = [];// 즐겨찾기만 따로 상태관리해서 실시간으로 업뎃되도록 해보자 !!

  //<함수> 드랍다운 메뉴에서 선택한 이름 업데이트 ( Not Reactive )
  void UpdateSelectedDropdownValue(newvalue){
    SelectedDropdownValue = newvalue; // 바뀐 성경이름으로 업뎃
    FressSearchList.value = [].obs; // 성경이름 바꿨으면, 검색결과 초기화
    update();
  }

  //<함수>자유검색 결과 리스트 받아오기
  Future<void> GetFreeSearchList(query) async {
    if (query.length>=2){ // 두글자 이상일떄만 쿼리
      FressSearchList.value = await BibleRepository.FreeSearchList(this.SelectedDropdownValue, query);
      InitUpdateTempBookmarkedList(); // 검새결과 새로고침할때마다 (임시)즐겨찾기 리스트 업데이트
      update();
    //print("$query에 대한 자유검색 결과를 불러와버렸즤 $FressSearchList");
    }else{
      update();
    }
  }

  // <함수> 자유검색 결과 클릭하면, 해당구절부터 메인에서 보여주기
  void FreeSearchContainerClick(int index){
    //1. 클릭 결과로부터  (BookName / Bookcode / ChapterNo / VerseNo)정보 업데이트하기
    BookName.value  = FressSearchList[index]['국문']; // 반응형이므로 value를 꼭 붙여줘야함 ㄷㄷ
    Bookcode        = FressSearchList[index]['bcode'];
    ChapterNo       = FressSearchList[index]['cnum'];
    VerseNo         = FressSearchList[index]['vnum'];
    BibleName       = SelectedDropdownValue; // 성경도 동일하게 해준다.
    //2. 결과 업데이트
    GetBibleSearchResult(); // 조건에 맞는 성경 재검색
    //3. 메인페이지 스크롤 초기화
    scrollController.jumpTo(0.0);
    //4. 현재 상태 저장
    SavePrefsData(); //상태값 저장
    update();
  }

  // (초기)즐겨찾기만 따로 상태관리해서 실시간으로 업뎃되도록 해보자 !!
  void InitUpdateTempBookmarkedList(){
    TempBookmarkedList = [];  // 배열 초기화 ( 계속쌓이는거 방지 )
    for (var i = 0; i < FressSearchList.length; i++){
      TempBookmarkedList.add(FressSearchList[i]['bookmarked']);
    }
  }
  // (수시)버튼을 누를때마다 해당 인덱스 즐겨찾기만 업뎃해주자 ㄱㄱ
  void FrequentlyUpdateTempBookmarkedList(index){
    //초기값 저장
    var init = TempBookmarkedList[index];
    //초기값과 반대로 저장해줘야하므로 조건문으로 확인해서 변경해준다.
    if(init==0){
      TempBookmarkedList[index] = 1;
    }else{
      TempBookmarkedList[index] = 0;
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
    update();
  }


  //<함수덮어쓰기>Worker를 이용한 이벤트 사용<ever, once, debounce, inverval>)
  @override
  void onInit(){
    super.onInit();

/*    // 마지막으로 변경된 이후, 1초간 변경이 없으면 실행 ( !!자원낭비가 심해서 일단 패스!! )
    debounce(SearchText, (callback){

      //1. 자유검색기능 호출
      GetFreeSearchList(callback);
      print("$callback 가 마지막으로 변경된 이후, 1초간 변경이 없습니다.");
      },
      time: const Duration(seconds: 1),
    );*/
  }

}