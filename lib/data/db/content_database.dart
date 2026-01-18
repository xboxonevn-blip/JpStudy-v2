import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'content_tables.dart';

part 'content_database.g.dart';

@DriftDatabase(
  tables: [
    Vocab,
    Grammar,
    Question,
    MockTest,
    MockTestSection,
    MockTestQuestionMap,
    UserProgress,
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase() : super(_openContentConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedMinnaVocabulary();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
        if (from < 3) {
          await m.addColumn(vocab, vocab.kanjiMeaning);
        }
        // Always re-seed Minna vocabulary (delete old + insert new)
        await _reseedMinnaVocabulary();
      },
    );
  }

  Future<void> _reseedMinnaVocabulary() async {
    // Delete all old Minna vocabulary
    await (delete(vocab)..where((tbl) => tbl.tags.like('%minna_%'))).go();
    
    // Seed new vocabulary
    await _seedMinnaVocabulary();
  }

  Future<void> _seedMinnaVocabulary() async {
    // Seed Minna No Nihongo Lessons 1-5 (119 terms)
    final vocabData = _getMinnaVocab();
    
    for (final item in vocabData) {
      await into(vocab).insert(
        VocabCompanion.insert(
          term: item['term']!,
          reading: Value(item['reading']),
          kanjiMeaning: Value(item['kanjiMeaning']),
          meaning: item['meaning']!,
          level: item['level']!,
          tags: Value(item['tags']),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  List<Map<String, String?>> _getMinnaVocab() {
    return [
      // ========== LESSON 1 (14 terms) ==========
      {'term': '私', 'reading': 'わたし', 'kanjiMeaning': 'tôi', 'meaning': 'tôi', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': '私たち', 'reading': 'わたしたち', 'kanjiMeaning': 'chúng tôi', 'meaning': 'chúng tôi', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': 'あなた', 'reading': 'あなた', 'kanjiMeaning': null, 'meaning': 'bạn', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': 'あの人', 'reading': 'あのひと', 'kanjiMeaning': 'người kia', 'meaning': 'người kia', 'level': 'N5', 'tags': 'minna_1,pronoun'},
      {'term': '先生', 'reading': 'せんせい', 'kanjiMeaning': 'tiên sinh', 'meaning': 'giáo viên', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '学生', 'reading': 'がくせい', 'kanjiMeaning': 'học sinh', 'meaning': 'học sinh', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '会社員', 'reading': 'かいしゃいん', 'kanjiMeaning': 'nhân viên công ty', 'meaning': 'nhân viên công ty', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '医者', 'reading': 'いしゃ', 'kanjiMeaning': 'thầy thuốc', 'meaning': 'bác sĩ', 'level': 'N5', 'tags': 'minna_1,occupation'},
      {'term': '大学', 'reading': 'だいがく', 'kanjiMeaning': 'đại học', 'meaning': 'trường đại học', 'level': 'N5', 'tags': 'minna_1,place'},
      {'term': '病院', 'reading': 'びょういん', 'kanjiMeaning': 'bệnh viện', 'meaning': 'bệnh viện', 'level': 'N5', 'tags': 'minna_1,place'},
      {'term': 'はい', 'reading': 'はい', 'kanjiMeaning': null, 'meaning': 'vâng', 'level': 'N5', 'tags': 'minna_1,response'},
      {'term': 'いいえ', 'reading': 'いいえ', 'kanjiMeaning': null, 'meaning': 'không', 'level': 'N5', 'tags': 'minna_1,response'},
      {'term': '初めまして', 'reading': 'はじめまして', 'kanjiMeaning': 'lần đầu gặp', 'meaning': 'hân hạnh được gặp', 'level': 'N5', 'tags': 'minna_1,phrase'},
      {'term': 'どうぞよろしく', 'reading': 'どうぞよろしく', 'kanjiMeaning': null, 'meaning': 'rất hân hạnh', 'level': 'N5', 'tags': 'minna_1,phrase'},
      
      // ========== LESSON 2 (20 terms) ==========
      {'term': 'これ', 'reading': 'これ', 'kanjiMeaning': null, 'meaning': 'cái này', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'それ', 'reading': 'それ', 'kanjiMeaning': null, 'meaning': 'cái đó', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'あれ', 'reading': 'あれ', 'kanjiMeaning': null, 'meaning': 'cái kia', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'この', 'reading': 'この', 'kanjiMeaning': null, 'meaning': '~ này', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'その', 'reading': 'その', 'kanjiMeaning': null, 'meaning': '~ đó', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': 'あの', 'reading': 'あの', 'kanjiMeaning': null, 'meaning': '~ kia', 'level': 'N5', 'tags': 'minna_2,pronoun'},
      {'term': '本', 'reading': 'ほん', 'kanjiMeaning': 'sách', 'meaning': 'sách', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '辞書', 'reading': 'じしょ', 'kanjiMeaning': 'từ điển', 'meaning': 'từ điển', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '新聞', 'reading': 'しんぶん', 'kanjiMeaning': 'báo mới', 'meaning': 'báo', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': 'ノート', 'reading': 'のーと', 'kanjiMeaning': null, 'meaning': 'vở', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '鉛筆', 'reading': 'えんぴつ', 'kanjiMeaning': 'bút chì', 'meaning': 'bút chì', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '時計', 'reading': 'とけい', 'kanjiMeaning': 'đồng hồ', 'meaning': 'đồng hồ', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': '傘', 'reading': 'かさ', 'kanjiMeaning': 'ô', 'meaning': 'cái ô', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': 'かばん', 'reading': 'かばん', 'kanjiMeaning': null, 'meaning': 'cặp', 'level': 'N5', 'tags': 'minna_2,things'},
      {'term': 'テレビ', 'reading': 'てれび', 'kanjiMeaning': null, 'meaning': 'ti vi', 'level': 'N5', 'tags': 'minna_2,electronics'},
      {'term': 'カメラ', 'reading': 'かめら', 'kanjiMeaning': null, 'meaning': 'máy ảnh', 'level': 'N5', 'tags': 'minna_2,electronics'},
      {'term': '机', 'reading': 'つくえ', 'kanjiMeaning': 'bàn', 'meaning': 'bàn', 'level': 'N5', 'tags': 'minna_2,furniture'},
      {'term': '英語', 'reading': 'えいご', 'kanjiMeaning': 'tiếng Anh', 'meaning': 'tiếng Anh', 'level': 'N5', 'tags': 'minna_2,language'},
      {'term': '日本語', 'reading': 'にほんご', 'kanjiMeaning': 'tiếng Nhật', 'meaning': 'tiếng Nhật', 'level': 'N5', 'tags': 'minna_2,language'},
      {'term': '何', 'reading': 'なん', 'kanjiMeaning': 'gì', 'meaning': 'cái gì', 'level': 'N5', 'tags': 'minna_2,question'},
      
      // ========== LESSON 3 (25 terms) ==========
      {'term': 'ここ', 'reading': 'ここ', 'kanjiMeaning': null, 'meaning': 'đây', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'そこ', 'reading': 'そこ', 'kanjiMeaning': null, 'meaning': 'đó', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'あそこ', 'reading': 'あそこ', 'kanjiMeaning': null, 'meaning': 'kia', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'どこ', 'reading': 'どこ', 'kanjiMeaning': null, 'meaning': 'đâu', 'level': 'N5', 'tags': 'minna_3,question'},
      {'term': 'こちら', 'reading': 'こちら', 'kanjiMeaning': null, 'meaning': 'đây (lịch sự)', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'そちら', 'reading': 'そちら', 'kanjiMeaning': null, 'meaning': 'đó (lịch sự)', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'あちら', 'reading': 'あちら', 'kanjiMeaning': null, 'meaning': 'kia (lịch sự)', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '教室', 'reading': 'きょうしつ', 'kanjiMeaning': 'phòng dạy', 'meaning': 'lớp học', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '食堂', 'reading': 'しょくどう', 'kanjiMeaning': 'phòng ăn', 'meaning': 'nhà ăn', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '事務所', 'reading': 'じむしょ', 'kanjiMeaning': 'văn phòng', 'meaning': 'văn phòng', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '会議室', 'reading': 'かいぎしつ', 'kanjiMeaning': 'phòng họp', 'meaning': 'phòng họp', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '受付', 'reading': 'うけつけ', 'kanjiMeaning': 'tiếp nhận', 'meaning': 'quầy lễ tân', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '部屋', 'reading': 'へや', 'kanjiMeaning': 'phòng', 'meaning': 'phòng', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'トイレ', 'reading': 'といれ', 'kanjiMeaning': null, 'meaning': 'WC', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '階段', 'reading': 'かいだん', 'kanjiMeaning': 'cầu thang', 'meaning': 'cầu thang', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': 'エレベーター', 'reading': 'えれべーたー', 'kanjiMeaning': null, 'meaning': 'thang máy', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '国', 'reading': 'くに', 'kanjiMeaning': 'nước', 'meaning': 'đất nước', 'level': 'N5', 'tags': 'minna_3,noun'},
      {'term': '会社', 'reading': 'かいしゃ', 'kanjiMeaning': 'công ty', 'meaning': 'công ty', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '家', 'reading': 'うち', 'kanjiMeaning': 'nhà', 'meaning': 'nhà', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '電話', 'reading': 'でんわ', 'kanjiMeaning': 'điện thoại', 'meaning': 'điện thoại', 'level': 'N5', 'tags': 'minna_3,noun'},
      {'term': '靴', 'reading': 'くつ', 'kanjiMeaning': 'giày', 'meaning': 'giày', 'level': 'N5', 'tags': 'minna_3,things'},
      {'term': '地下', 'reading': 'ちか', 'kanjiMeaning': 'dưới đất', 'meaning': 'tầng hầm', 'level': 'N5', 'tags': 'minna_3,place'},
      {'term': '何階', 'reading': 'なんがい', 'kanjiMeaning': 'tầng mấy', 'meaning': 'tầng mấy', 'level': 'N5', 'tags': 'minna_3,question'},
      {'term': 'いくら', 'reading': 'いくら', 'kanjiMeaning': null, 'meaning': 'bao nhiêu', 'level': 'N5', 'tags': 'minna_3,question'},
      {'term': 'すみません', 'reading': 'すみません', 'kanjiMeaning': null, 'meaning': 'xin lỗi', 'level': 'N5', 'tags': 'minna_3,phrase'},
      
      // ========== LESSON 4 (30 terms) ==========
      {'term': '起きます', 'reading': 'おきます', 'kanjiMeaning': 'thức dậy', 'meaning': 'dậy', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': '寝ます', 'reading': 'ねます', 'kanjiMeaning': 'ngủ', 'meaning': 'ngủ', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': '働きます', 'reading': 'はたらきます', 'kanjiMeaning': 'làm việc', 'meaning': 'làm việc', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': '休みます', 'reading': 'やすみます', 'kanjiMeaning': 'nghỉ', 'meaning': 'nghỉ', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': '勉強します', 'reading': 'べんきょうします', 'kanjiMeaning': 'học tập', 'meaning': 'học', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': '終わります', 'reading': 'おわります', 'kanjiMeaning': 'kết thúc', 'meaning': 'kết thúc', 'level': 'N5', 'tags': 'minna_4,verb'},
      {'term': 'デパート', 'reading': 'でぱーと', 'kanjiMeaning': null, 'meaning': 'cửa hàng bách hóa', 'level': 'N5', 'tags': 'minna_4,place'},
      {'term': '銀行', 'reading': 'ぎんこう', 'kanjiMeaning': 'ngân hàng', 'meaning': 'ngân hàng', 'level': 'N5', 'tags': 'minna_4,place'},
      {'term': '郵便局', 'reading': 'ゆうびんきょく', 'kanjiMeaning': 'cục bưu điện', 'meaning': 'bưu điện', 'level': 'N5', 'tags': 'minna_4,place'},
      {'term': '図書館', 'reading': 'としょかん', 'kanjiMeaning': 'thư viện', 'meaning': 'thư viện', 'level': 'N5', 'tags': 'minna_4,place'},
      {'term': '今', 'reading': 'いま', 'kanjiMeaning': 'bây giờ', 'meaning': 'bây giờ', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '朝', 'reading': 'あさ', 'kanjiMeaning': 'sáng', 'meaning': 'buổi sáng', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '昼', 'reading': 'ひる', 'kanjiMeaning': 'trưa', 'meaning': 'buổi trưa', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '晩', 'reading': 'ばん', 'kanjiMeaning': 'tối', 'meaning': 'buổi tối', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '午前', 'reading': 'ごぜん', 'kanjiMeaning': 'trước ngọ', 'meaning': 'sáng (AM)', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '午後', 'reading': 'ごご', 'kanjiMeaning': 'sau ngọ', 'meaning': 'chiều (PM)', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '昨日', 'reading': 'きのう', 'kanjiMeaning': 'hôm qua', 'meaning': 'hôm qua', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '今日', 'reading': 'きょう', 'kanjiMeaning': 'hôm nay', 'meaning': 'hôm nay', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '明日', 'reading': 'あした', 'kanjiMeaning': 'ngày mai', 'meaning': 'ngày mai', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '今朝', 'reading': 'けさ', 'kanjiMeaning': 'sáng nay', 'meaning': 'sáng nay', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '今晩', 'reading': 'こんばん', 'kanjiMeaning': 'tối nay', 'meaning': 'tối nay', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '毎日', 'reading': 'まいにち', 'kanjiMeaning': 'mỗi ngày', 'meaning': 'hàng ngày', 'level': 'N5', 'tags': 'minna_4,time'},
      {'term': '月曜日', 'reading': 'げつようび', 'kanjiMeaning': 'thứ hai', 'meaning': 'thứ Hai', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '火曜日', 'reading': 'かようび', 'kanjiMeaning': 'thứ ba', 'meaning': 'thứ Ba', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '水曜日', 'reading': 'すいようび', 'kanjiMeaning': 'thứ tư', 'meaning': 'thứ Tư', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '木曜日', 'reading': 'もくようび', 'kanjiMeaning': 'thứ năm', 'meaning': 'thứ Năm', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '金曜日', 'reading': 'きんようび', 'kanjiMeaning': 'thứ sáu', 'meaning': 'thứ Sáu', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '土曜日', 'reading': 'どようび', 'kanjiMeaning': 'thứ bảy', 'meaning': 'thứ Bảy', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '日曜日', 'reading': 'にちようび', 'kanjiMeaning': 'chủ nhật', 'meaning': 'Chủ nhật', 'level': 'N5', 'tags': 'minna_4,day'},
      {'term': '何曜日', 'reading': 'なんようび', 'kanjiMeaning': 'thứ mấy', 'meaning': 'thứ mấy', 'level': 'N5', 'tags': 'minna_4,question'},
      
      // ========== LESSON 5 (30 terms) ==========
      {'term': '行きます', 'reading': 'いきます', 'kanjiMeaning': 'đi', 'meaning': 'đi', 'level': 'N5', 'tags': 'minna_5,verb'},
      {'term': '来ます', 'reading': 'きます', 'kanjiMeaning': 'đến', 'meaning': 'đến', 'level': 'N5', 'tags': 'minna_5,verb'},
      {'term': '帰ります', 'reading': 'かえります', 'kanjiMeaning': 'về', 'meaning': 'về', 'level': 'N5', 'tags': 'minna_5,verb'},
      {'term': '電車', 'reading': 'でんしゃ', 'kanjiMeaning': 'xe lửa điện', 'meaning': 'tàu điện', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '車', 'reading': 'くるま', 'kanjiMeaning': 'xe', 'meaning': 'xe hơi', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '自転車', 'reading': 'じてんしゃ', 'kanjiMeaning': 'xe đạp', 'meaning': 'xe đạp', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '飛行機', 'reading': 'ひこうき', 'kanjiMeaning': 'máy bay', 'meaning': 'máy bay', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '船', 'reading': 'ふね', 'kanjiMeaning': 'thuyền', 'meaning': 'tàu', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '地下鉄', 'reading': 'ちかてつ', 'kanjiMeaning': 'xe lửa ngầm', 'meaning': 'tàu điện ngầm', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '新幹線', 'reading': 'しんかんせん', 'kanjiMeaning': 'đường chính mới', 'meaning': 'tàu cao tốc', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': 'バス', 'reading': 'ばす', 'kanjiMeaning': null, 'meaning': 'xe buýt', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': 'タクシー', 'reading': 'たくしー', 'kanjiMeaning': null, 'meaning': 'taxi', 'level': 'N5', 'tags': 'minna_5,transport'},
      {'term': '歩いて', 'reading': 'あるいて', 'kanjiMeaning': 'đi bộ', 'meaning': 'đi bộ', 'level': 'N5', 'tags': 'minna_5,adverb'},
      {'term': '学校', 'reading': 'がっこう', 'kanjiMeaning': 'trường học', 'meaning': 'trường', 'level': 'N5', 'tags': 'minna_5,place'},
      {'term': 'スーパー', 'reading': 'すーぱー', 'kanjiMeaning': null, 'meaning': 'siêu thị', 'level': 'N5', 'tags': 'minna_5,place'},
      {'term': '駅', 'reading': 'えき', 'kanjiMeaning': 'trạm', 'meaning': 'nhà ga', 'level': 'N5', 'tags': 'minna_5,place'},
      {'term': '人', 'reading': 'ひと', 'kanjiMeaning': 'người', 'meaning': 'người', 'level': 'N5', 'tags': 'minna_5,noun'},
      {'term': '友達', 'reading': 'ともだち', 'kanjiMeaning': 'bạn', 'meaning': 'bạn bè', 'level': 'N5', 'tags': 'minna_5,noun'},
      {'term': '家族', 'reading': 'かぞく', 'kanjiMeaning': 'gia tộc', 'meaning': 'gia đình', 'level': 'N5', 'tags': 'minna_5,noun'},
      {'term': '一人で', 'reading': 'ひとりで', 'kanjiMeaning': 'một người', 'meaning': 'một mình', 'level': 'N5', 'tags': 'minna_5,adverb'},
      {'term': '先週', 'reading': 'せんしゅう', 'kanjiMeaning': 'tuần trước', 'meaning': 'tuần trước', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '今週', 'reading': 'こんしゅう', 'kanjiMeaning': 'tuần này', 'meaning': 'tuần này', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '来週', 'reading': 'らいしゅう', 'kanjiMeaning': 'tuần tới', 'meaning': 'tuần sau', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '先月', 'reading': 'せんげつ', 'kanjiMeaning': 'tháng trước', 'meaning': 'tháng trước', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '今月', 'reading': 'こんげつ', 'kanjiMeaning': 'tháng này', 'meaning': 'tháng này', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '来月', 'reading': 'らいげつ', 'kanjiMeaning': 'tháng tới', 'meaning': 'tháng sau', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '去年', 'reading': 'きょねん', 'kanjiMeaning': 'năm ngoái', 'meaning': 'năm ngoái', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '今年', 'reading': 'ことし', 'kanjiMeaning': 'năm nay', 'meaning': 'năm nay', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': '来年', 'reading': 'らいねん', 'kanjiMeaning': 'năm tới', 'meaning': 'năm sau', 'level': 'N5', 'tags': 'minna_5,time'},
      {'term': 'いつ', 'reading': 'いつ', 'kanjiMeaning': null, 'meaning': 'khi nào', 'level': 'N5', 'tags': 'minna_5,question'},
    ];
  }
}

LazyDatabase _openContentConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'content.sqlite'));
    
    // Always create fresh database (no asset copy)
    // Migration will handle seeding
    return NativeDatabase(file);
  });
}
