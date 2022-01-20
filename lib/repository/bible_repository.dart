
import 'package:echo/repository/bible_database.dart';

class BibleRepository {

  // 권(book) = 창세기 / 출애굽기 등등 리스트 가져오기
  static Future<List<Map<String, dynamic>>> GetBookList() async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "bibles",
        columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        orderBy: "_id"
    );
  }

  // (장<chapter> 가져오기)
  static Future<List<Map<String, dynamic>>> ChapterList(int bcode) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "verses",
        columns: ["cnum"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        distinct: true, // 중복제거
        where: ' bcode =:bcode', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [bcode],
        orderBy: '_id asc'
    );
  }
  // (절<verse> 가져오기)
  static Future<List<Map<String, dynamic>>> VerseList(int bcode, int cnum) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        "verses",
        columns: ["vnum"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        distinct: true,
        where: ' bcode =:bcode and cnum=:cnum', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [bcode, cnum],
        orderBy: '_id asc'
    );
  }

  // 해당구절 _Id 가져오기
  static Future<List<Map<String, dynamic>>> GetContentId(int Bookcode, int ChapterNo, int VerseNo) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
    """
      SELECT *
      FROM verses
      WHERE bcode = $Bookcode and cnum =$ChapterNo and vnum = $VerseNo
    """
    );
    return result;
  }


  // (성경구절<content> 가져오기 with 갯수정보) with id정보와 갯수로
  static Future<List<Map<String, dynamic>>> GetContent(int id, int number, String BibleName) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
        """
          SELECT verses._id, verses.bcode, cnum, vnum, bookmarked, bookmark_updated_at, 국문, 영문, $BibleName
          FROM
          (
            SELECT _id, bcode, cnum, vnum, bookmarked, bookmark_updated_at, $BibleName
            FROM verses 
          ) AS verses
          INNER JOIN bibles
          ON verses.bcode = bibles.bcode
          
          WHERE verses._id BETWEEN $id and ${id+number-1};
        """
    );
    return result;
  }


  // 조건에 맞는 성경이름 가져오기 ( ex: 창세기 / 출애굽기 / 레위기 / 요한계시록 등등 )
  static Future<List<Map<String, dynamic>>> GetBibleName(String vcode, int bcode) async {
    var db = await BibleDatabase.getDb();
    var result =  db.query(
      "bibles",
      columns: ["name"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
      where: ' vcode =:vcode and bcode =:bcode', //' vcode ="GAE" and type like "%ld%" ',
      whereArgs: [vcode, bcode],
    );
    return result;
  }


  // 자유검색 ( 성경 구절에 일치하는 단어를 통해서 검색하는 기능 )
  static Future<List<Map<String, dynamic>>> FreeSearchList(String BibleName, String query) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
      """
        SELECT verses._id, verses.bcode, cnum, vnum, bookmarked, 국문, 영문, $BibleName
        FROM
        (
          SELECT _id, bcode, cnum, vnum, bookmarked, $BibleName
          FROM verses 
        ) AS verses
        INNER JOIN bibles
        ON verses.bcode = bibles.bcode
        WHERE $BibleName like '%$query%'
      """
    );
    return result;
  }

  // 북마크(즐겨찾기(bookmarked))업데이트 하기 ( 업데이트가 발생한 시간도 함께 입력 )
  Future<void> UpdateBookmarked(int _id, int bookmarked) async {
    var db = await BibleDatabase.getDb();
    final data = {
      'bookmarked': bookmarked,
      'bookmark_updated_at': DateTime.now().toString() // (매우중요)
    };
    await db.update('verses', data, where: "_id = ?", whereArgs: [_id]);
  }

  // 즐겨찾기 리스트 검색, 북마크(즐겨찾기(bookmarked))가져오기
  static Future<List<Map<String, dynamic>>> GetBookmarkedList(String BibleName, String Order) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
        """
        SELECT verses._id, verses.bcode, cnum, vnum, bookmarked, bookmark_updated_at,국문, 영문, $BibleName
        FROM
        (
          SELECT _id, bcode, cnum, vnum, bookmarked, bookmark_updated_at, $BibleName
          FROM verses 
        ) AS verses
        INNER JOIN bibles
        ON verses.bcode = bibles.bcode
        WHERE bookmarked = 1
        ORDER by $Order
      """
    );
    return result;
  }

  // 성경이름 자유검색 ( ex: 창세기, 출애굽기 등등 검색 하는 기능 + 국&영문 동시)
  static Future<List<Map<String, dynamic>>> BibleSearch(String query) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
      """
          SELECT *
          FROM bibles
          WHERE 국문 like '%$query%' or 영문 like '%$query%'
          ORDER by _id ASC
      """
    );
    return result;
  }


  //////////////아래는 안쓰는 녀석들///////////////

  // (성경구절<content> 가져오기 with 갯수정보) JOIN with "Bibles" : 성경(book)이름도 같이 가져오기 위해
  static Future<List<Map<String, dynamic>>> GetContent_temp(int Bookcode, int ChapterNo, int VerseNo, int number, String BibleName) async {
    var db = await BibleDatabase.getDb();
    var result =  db.rawQuery(
        """
          SELECT verses._id, verses.bcode, cnum, vnum, bookmarked, 국문, 영문, $BibleName
          FROM
          (
            SELECT _id, bcode, cnum, vnum, bookmarked, $BibleName
            FROM verses 
          ) AS verses
          INNER JOIN bibles
          ON verses.bcode = bibles.bcode
          
          WHERE verses._id BETWEEN 
            (
              SELECT verses._id
              FROM verses
              WHERE bcode=$Bookcode and cnum=$ChapterNo and vnum=$VerseNo
            )
              and 
            (
              SELECT verses._id
              FROM verses
              WHERE bcode=$Bookcode and cnum=$ChapterNo and vnum=${VerseNo+number-1}
            );
        """
    );
    return result;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems(String TableName, String vcode) async {
    var db = await BibleDatabase.getDb();
    return db.query(
        TableName,
        columns: ["*"], // ['vcode', 'bcode', 'type', 'name', 'chapter_count'],
        where: ' vcode =:vcode ', //' vcode ="GAE" and type like "%ld%" ',
        whereArgs: [vcode],
        orderBy: "_id"
    );
  }

  // 북마크(즐겨찾기(bookmarked))업데이트 하기( ORM 스타일로 변경함 )
  Future<void> UpdateBookmarked_temp(int _id, int bookmarked) async {
    var db = await BibleDatabase.getDb();
    await db.rawUpdate(
        'update verses set bookmarked =:bookmarked where _id=:_id',
        [bookmarked, _id]
    );
  }


}
