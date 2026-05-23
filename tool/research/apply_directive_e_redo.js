const fs = require('node:fs');
const path = require('node:path');

const {
  validateDirectiveEItem,
  readDirectiveEItems,
} = (() => {
  const validator = require('../qa/validate_directive_e_quality');
  return {
    validateDirectiveEItem: validator.validateDirectiveEItem,
    readDirectiveEItems: validator.readGrammarDirectiveEItems,
  };
})();

const FALLBACK_REFERENCE = {
  sourceCredit: "Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0)",
  sourceUrl: 'https://guidetojapanese.org/learn/grammar',
  license: 'CC-BY-NC-SA 3.0',
  usePolicy:
    'Fallback reference only; JpStudy writes original Vietnamese guidance and does not copy source prose.',
  guideSection: 'particles',
};

function buildDirectiveE({ item, level = 'N5', neighborStructures = [] }) {
  const structure = clean(item.structure || item.title || item.structureEn || 'mẫu này');
  const title = clean(item.title || structure);
  const explanation = firstSentence(clean(item.explanation || item.explanationViDraft || item.explanationEn));
  const pattern = displayPattern(structure, title);
  const contrast = firstUsefulNeighbor(neighborStructures, pattern) || fallbackContrast(pattern);
  const profile = directiveEProfile({ pattern, title, explanation });
  const contrastProfile = directiveEProfile({ pattern: contrast, title: contrast, explanation: '' });
  const meaning = explanation || profile.meaning;
  const bridge = kanjiBridge(pattern, profile);

  return {
    etymology:
      `Gốc cấu trúc của ${pattern}: ${profile.root}. Trong công thức ${structure}, ${profile.formCue}; ` +
      `vì vậy phần ${profile.anchor} không được học như từ rời mà như dấu nối chức năng của cả cụm.`,
    hanVietBridge: bridge,
    form:
      `Hình thức: ${structure}. Dấu cần khóa là ${profile.formCue}; sau đó kiểm tra phần trước có đúng dạng từ mà mẫu yêu cầu không.`,
    meaning:
      `Ý nghĩa: ${meaning}. Với ${pattern}, trọng tâm là ${profile.meaning}; đọc xong lõi này rồi mới chọn bản dịch tự nhiên cho cả câu.`,
    usage:
      `Sử dụng: ${profile.usage}. Nếu dạng đứng trước lệch khỏi ${profile.anchor}, nghĩa rất dễ trôi sang một mẫu gần âm hoặc gần chữ khác.`,
    humanMoment:
      `Dr. Linh lưu ý: ${pattern} xoay quanh ${profile.humanCue}. Khác ${contrast}, ${profile.contrastCue}; ` +
      `gặp ${profile.signal} thì giữ nghĩa ${profile.result}, đừng kéo sang ${contrastProfile.result}.`,
    crossLinks: [
      {
        pattern: contrast,
        contrast:
          `Khác ${pattern}: ${contrast} nghiêng về ${contrastProfile.result}, còn ${pattern} nghiêng về ${profile.result}. ` +
          `So dấu ${profile.signal} với ${contrastProfile.signal} trước khi chọn cách dịch.`,
      },
    ],
    fallbackReference: { ...FALLBACK_REFERENCE },
  };
}

function directiveEProfile({ pattern, title, explanation }) {
  const text = `${pattern} ${title} ${explanation}`;
  const normalizedText = normalize(text);
  const rule = PROFILE_RULES.find((entry) => entry.re.test(normalizedText));
  const anchor = rule?.anchor || japaneseAnchor(pattern, title);
  const meaning = clean(rule?.meaning || meaningFromExplanation(explanation) || 'mối quan hệ ngữ pháp riêng của mẫu');
  const result = clean(rule?.result || meaning);
  const signal = clean(rule?.signal || anchor);
  const humanCue = clean(rule?.humanCue || `${signal} trong ${pattern} báo ${meaning}`);
  return {
    anchor,
    signal,
    meaning,
    result,
    humanCue,
    root: clean(rule?.root || `${anchor} là phần neo của mẫu; nó gom cụm đứng trước thành một đơn vị để biểu thị ${meaning}`),
    formCue: clean(rule?.formCue || `dấu ${anchor} và dạng từ ngay trước nó`),
    usage: clean(rule?.usage || `Dùng ${pattern} khi muốn biểu thị ${meaning}; ưu tiên kiểm tra dấu ${signal} trong câu mẫu`),
    contrastCue: clean(rule?.contrastCue || `${pattern} giữ trọng tâm ${result}, còn mẫu kia đổi điểm neo hoặc sắc thái`),
  };
}

const PROFILE_RULES = [
  profile(/そう.*(nghenói|truyềnđạt|theodựbáo|によると|伝聞)|によると|によれば|とのこと/, 'そう',
    'そう trong truyền văn giữ cảm giác "như thế theo nguồn tin"; cả mệnh đề thường đứng trước được đóng gói thành nội dung nghe hoặc đọc được.',
    'thể thường trước そうです, riêng danh từ và tính từ na giữ だ',
    'truyền đạt nguồn tin bên ngoài',
    'Dùng khi có căn cứ nghe/đọc được, thường đi với によると; không dùng cho dáng vẻ nhìn thấy ngay trước mắt.',
    'nguồn tin được truyền lại',
    'そうです đánh dấu lời nghe được từ nguồn khác',
    'mẫu kia thường dựa vào quan sát, suy luận hoặc sắc thái thân mật hơn',
    'lời nghe được'),
  profile(/そう|様態/, 'そう',
    'そう trong dạng vẻ bám vào thân động từ hoặc thân tính từ để nói ấn tượng nhìn thấy trước khi sự việc xảy ra.',
    'Vます語幹 hoặc gốc tính từ trước そう, không đặt だ như truyền văn',
    'dáng vẻ hoặc khả năng sắp xảy ra',
    'Dùng khi mắt thấy dấu hiệu như 雨が降りそう; tránh lẫn với そうです truyền tin theo nguồn.',
    'dáng vẻ nhìn thấy',
    'そうだ dạng vẻ báo ấn tượng trực tiếp',
    'mẫu kia thường kể lại thông tin hoặc suy đoán theo nguồn khác',
    'dáng vẻ'),
  profile(/らしい/, 'らしい',
    'らしい gắn sau cụm thường để nói thông tin nghe được hoặc nét "đúng chất" của người/vật.',
    'cụm thường hoặc danh từ đi thẳng vào らしい',
    'thông tin bên ngoài hoặc tính điển hình',
    'Dùng khi muốn nói "nghe có vẻ/đúng chất"; kiểm tra xem câu đang nêu nguồn tin hay đặc tính điển hình.',
    'nguồn tin hoặc nét đúng chất',
    'らしい thường nghe như nhận định từ bên ngoài',
    'mẫu kia thường dựa trên cảm giác trực tiếp hoặc mức thân mật khác',
    'vẻ đúng chất'),
  profile(/みたい/, 'みたい',
    'みたい là cách nói thân mật mang nghĩa "giống như/có vẻ", gần よう nhưng nhẹ và đời thường hơn.',
    'danh từ hoặc cụm thường nối thẳng vào みたい',
    'so sánh/cảm giác thân mật',
    'Dùng trong hội thoại; trong văn trang trọng đổi sang ようだ hoặc ようです.',
    'cảm giác giống như trong khẩu ngữ',
    'みたい kéo câu về văn nói',
    'mẫu kia trang trọng hơn hoặc dựa vào nguồn tin rõ hơn',
    'vẻ giống thân mật'),
  profile(/よう|様/, 'よう',
    'よう bắt nguồn từ 様, ý "dạng/dáng"; mẫu mượn hình ảnh cái gì đó có vẻ hoặc hướng về một trạng thái.',
    'よう cùng の sau danh từ hoặc な sau tính từ na',
    'vẻ giống, mục tiêu, hoặc trạng thái hướng tới',
    'Dùng khi cần nói "như/có vẻ/để sao cho"; nhớ kiểm tra の, な, hoặc に sau よう.',
    'dáng/hướng của よう',
    'よう giữ hình ảnh "dáng như vậy"',
    'mẫu kia thường trực tiếp hơn hoặc thân mật hơn, không cần bộ đệm 様/よう',
    'vẻ hoặc hướng'),
  profile(/らしい/, 'らしい',
    'らしい gắn sau cụm thường để nói thông tin nghe được hoặc nét "đúng chất" của người/vật.',
    'cụm thường hoặc danh từ đi thẳng vào らしい',
    'thông tin bên ngoài hoặc tính điển hình',
    'Dùng khi muốn nói "nghe có vẻ/đúng chất"; kiểm tra xem câu đang nêu nguồn tin hay đặc tính điển hình.',
    'nguồn tin hoặc nét đúng chất',
    'らしい thường nghe như nhận định từ bên ngoài',
    'mẫu kia thường dựa trên cảm giác trực tiếp hoặc mức thân mật khác',
    'vẻ đúng chất'),
  profile(/みたい/, 'みたい',
    'みたい là cách nói thân mật mang nghĩa "giống như/có vẻ", gần よう nhưng nhẹ và đời thường hơn.',
    'danh từ hoặc cụm thường nối thẳng vào みたい',
    'so sánh/cảm giác thân mật',
    'Dùng trong hội thoại; trong văn trang trọng đổi sang ようだ hoặc ようです.',
    'cảm giác giống như trong khẩu ngữ',
    'みたい kéo câu về văn nói',
    'mẫu kia trang trọng hơn hoặc dựa vào nguồn tin rõ hơn',
    'vẻ giống thân mật'),
  profile(/んです|のです/, 'んです',
    'んです là のです rút gọn; の biến cả mệnh đề trước thành "chuyện/điều" để người nói giải thích.',
    'thể thường trước んです, danh từ và tính từ na đổi thành なんです',
    'giải thích, mở lời, hoặc nhấn nền thông tin',
    'Dùng khi câu trả lời cần lý do ngầm hoặc lời dẫn mềm; không dùng như です lịch sự thông thường.',
    'phần giải thích nằm trong ん',
    'んです đặt một lớp giải thích phía sau câu',
    'mẫu kia thường là yêu cầu/lời khuyên trực tiếp, không tạo lớp nền giải thích',
    'giải thích'),
  profile(/いただけませんか|いただき|くださ|ください|あげ|もら|くれ|やり/, '授受',
    'nhóm cho-nhận trong tiếng Nhật mã hóa hướng lợi ích và thứ bậc xã hội, không chỉ hành động "cho".',
    'động từ te-form hoặc danh từ quà tặng cộng người nhận/nguồn nhận',
    'hướng lợi ích và độ lịch sự',
    'Dùng sau khi xác định ai được lợi và vị thế người nói; đổi あげる, もらう, くれる là đổi hướng mũi tên.',
    'hướng cho-nhận',
    'mẫu cho-nhận hỏi "lợi ích chạy về phía ai"',
    'mẫu kia đổi hướng lợi ích hoặc mức kính trọng',
    'hướng lợi ích'),
  profile(/使役|させ/, '使役',
    '使役 biến chủ thể thành người khiến/cho phép người khác làm hành động; đuôi せる/させる là dấu đổi vai.',
    'động từ sai khiến và người bị sai khiến với を hoặc に',
    'bắt buộc hoặc cho phép ai làm gì',
    'Dùng khi chủ thể tạo điều kiện hoặc ép hành động; phân biệt người bị tác động dùng を hay に theo loại động từ.',
    'vai người khiến trong 使役',
    '使役 luôn hỏi ai khiến ai làm gì',
    'mẫu kia thường là bị động hoặc nhờ vả, vai chủ thể đảo khác',
    'sai khiến/cho phép'),
  profile(/受身|被動|れる|られる/, '受身',
    '受身 đưa người/vật chịu tác động lên làm chủ đề; đuôi れる/られる báo câu đang nhìn từ phía người nhận tác động.',
    'chủ đề chịu tác động, người gây tác động thường đi với に',
    'bị/được ai đó làm gì hoặc chịu phiền',
    'Dùng khi kết quả rơi lên chủ đề; chú ý 迷惑の受け身 vì tiếng Việt thường phải thêm sắc thái bị phiền.',
    'người chịu tác động',
    '受身 kéo camera về phía người bị ảnh hưởng',
    'mẫu kia thường là sai khiến hoặc kính ngữ cùng hình れる/られる nhưng vai nghĩa khác',
    'bị động'),
  profile(/尊敬|お\+|ご\+|になります|お\/ご/, '尊敬語',
    '尊敬語 nâng hành động của người trên hoặc khách lên; お/ご là tiền tố lịch sự, còn になる/ください gắn vào khung kính trọng.',
    'お + Vます語幹 hoặc ご + Hán ngữ trước động từ kính trọng',
    'nâng hành động của người khác',
    'Dùng cho hành động của người nghe/người được kính trọng; không dùng để tự nâng hành động của mình.',
    'đối tượng được nâng lên',
    '尊敬語 hỏi hành động thuộc về ai để nâng người đó',
    'mẫu kia có thể là khiêm nhường, tức hạ hành động của mình thay vì nâng người khác',
    'kính trọng'),
  profile(/謙譲|ございます|でございます|お.*します|ご.*します/, '謙譲語',
    '謙譲語 hạ hành động của phía mình để tôn người đối diện; ございます là dạng lịch sự trang trọng của あります/です.',
    'お/ご + thân từ + します hoặc danh từ/tính từ na + でございます',
    'hạ mình hoặc làm câu trang trọng',
    'Dùng cho hành động thuộc phía người nói; nếu hành động là của khách/người trên, chuyển sang 尊敬語.',
    'phía người nói được hạ xuống',
    '謙譲語 không nâng mình mà hạ phía mình',
    'mẫu kia thường nâng người khác hoặc chỉ là lịch sự trung tính',
    'khiêm nhường'),
  profile(/ことにする/, 'こと',
    'こと/事 biến hành động thành một "sự việc"; にする đặt sự việc đó vào quyết định chủ động.',
    'V辞書 hoặc Vない trước ことにする',
    'tự quyết làm hoặc không làm',
    'Dùng cho quyết định cá nhân sau cân nhắc; không dùng khi kết quả do lịch trình/quy định quyết định.',
    'quyết định chủ động',
    'ことにする có ý chí của người quyết',
    'mẫu kia thường là kết quả được sắp bởi hoàn cảnh',
    'tự quyết'),
  profile(/ことになる|ことになっている/, 'こと',
    'こと/事 danh từ hóa hành động; になる biến "sự việc" ấy thành kết quả hoặc quy định hình thành từ bên ngoài.',
    'V辞書 hoặc Vない trước ことになる/ことになっている',
    'kết quả khách quan hoặc quy định',
    'Dùng khi quyết định đến từ lịch trình, tổ chức, quy tắc; không nhấn ý chí cá nhân.',
    'kết quả đã thành',
    'ことになる đẩy quyết định ra ngoài người nói',
    'mẫu kia thường là tự quyết bằng にする',
    'kết quả/qui định'),
  profile(/こと|事/, 'こと',
    'こと/事 biến động tác hoặc mệnh đề thành một danh từ trừu tượng để đem ra nói, đánh giá hoặc nối tiếp.',
    'mệnh đề thường trước こと',
    'danh từ hóa một sự việc',
    'Dùng khi cả hành động cần đứng ở vị trí của danh từ như chủ ngữ, tân ngữ hoặc nội dung quy định.',
    'sự việc được danh từ hóa',
    'こと đóng gói hành động thành "việc"',
    'mẫu kia thường nói trải nghiệm, bản chất hoặc kết quả chứ không chỉ đóng gói sự việc',
    'sự việc'),
  profile(/もの|物/, 'もの',
    'もの/物 vốn là "vật/điều"; trong ngữ pháp nó kéo câu về bản chất, cảm xúc tự nhiên hoặc lý do mang tính con người.',
    'cụm thường trước もの hoặc ものだ/ものだから',
    'bản chất, cảm xúc hoặc lý do tự nhiên',
    'Dùng khi muốn nêu điều vốn dĩ, cảm giác mạnh, hoặc lời giải thích mềm; tránh thay bằng こと khi cần sắc thái con người.',
    'bản chất của もの',
    'もの thường có hơi người và cảm xúc hơn こと',
    'mẫu kia thường trung tính hơn hoặc chỉ đóng gói sự việc',
    'bản chất/cảm xúc'),
  profile(/わけ/, 'わけ',
    'わけ mang nghĩa lý do/lẽ; mẫu dùng nó để kết luận điều hợp logic hoặc phủ định một suy diễn.',
    'mệnh đề thường trước わけ',
    'lý do, lẽ phải, hoặc suy luận',
    'Dùng khi câu đang giải thích vì sao kết luận hợp lý, không hợp lý, hoặc không thể làm vì ràng buộc xã hội.',
    'lẽ/suy luận của わけ',
    'わけ hỏi "vì lẽ nào kết luận này đúng"',
    'mẫu kia thường nói kỳ vọng bằng はず hoặc quyết định bằng こと',
    'lý do logic'),
  profile(/はず/, 'はず',
    'はず diễn tả kỳ vọng hợp lý dựa trên dữ kiện; nó không phải cam kết chắc chắn tuyệt đối.',
    'cụm thường trước はず',
    'điều đáng lẽ/logic phải đúng',
    'Dùng khi có bằng chứng để dự đoán; nếu chỉ là cảm giác yếu, chuyển sang かもしれない hoặc でしょう.',
    'kỳ vọng có căn cứ',
    'はず cần một căn cứ trong đầu người nói',
    'mẫu kia thường giải thích lý do bằng わけ hoặc đoán mềm hơn',
    'kỳ vọng'),
  profile(/ばかり|だけ|しか|ほど|くらい|ぐらい/, '限定',
    'nhóm giới hạn đặt một ranh lượng: chỉ có, vừa mới, càng, hoặc mức độ so sánh.',
    'danh từ/động từ cộng dấu giới hạn như しか, だけ, ばかり, ほど',
    'giới hạn số lượng, mức độ, hoặc thời điểm',
    'Dùng sau khi xác định mẫu có cần phủ định không; riêng しか phải đi với động từ phủ định.',
    'ranh giới lượng',
    'dấu giới hạn quyết định câu là "chỉ", "vừa", hay "đến mức"',
    'mẫu kia có thể cùng nói ít/nhiều nhưng khác yêu cầu phủ định hoặc sắc thái',
    'giới hạn'),
  profile(/ところ|とたん|たび|ついで|際|折|末|あげく|以来|前に|あと|間に|うちに|まで/, '時点',
    'nhóm thời điểm neo câu vào một lát cắt của tiến trình: trước, sau, đúng lúc, mỗi lần, hoặc sau một quá trình.',
    'dạng động từ trước dấu thời điểm',
    'mốc thời gian trong tiến trình',
    'Dùng khi quan hệ thời gian là thông tin chính; kiểm tra Vる, Vた, Vている vì đổi dạng là đổi mốc nhìn.',
    'mốc thời gian',
    'mẫu thời điểm hỏi sự việc xảy ra ở lát cắt nào',
    'mẫu kia thường đổi mốc trước/sau hoặc sắc thái đột ngột',
    'thời điểm'),
  profile(/ため|ので|から|おかげ|せい|につき|ことから|あまり/, '理由',
    'nhóm lý do nối nguyên nhân với kết quả; mỗi dấu cho biết sắc thái khách quan, biết ơn, tiêu cực, hay quá mức.',
    'cụm nguyên nhân trước dấu lý do',
    'nguyên nhân hoặc mục đích',
    'Dùng khi vế sau là kết quả tự nhiên hoặc mục tiêu; phân biệt ために mục đích với ために lý do bằng ý chí của vế trước.',
    'mối nối nguyên nhân',
    'dấu lý do hỏi kết quả sinh ra từ đâu',
    'mẫu kia có thể cùng dịch là "vì" nhưng đổi sắc thái khách quan/chủ quan',
    'lý do/mục đích'),
  profile(/ば|たら|なら|ても|としても|にしろ|どんなに|ことには/, '条件',
    'nhóm điều kiện đặt một giả định trước rồi xem kết luận có xảy ra, đổi hướng hay vẫn giữ nguyên không.',
    'dạng điều kiện như ば, たら, なら, ても',
    'điều kiện, nhượng bộ, hoặc giả định',
    'Dùng sau khi xác định vế trước là điều kiện thật, giả định, hay nhượng bộ; ても thường giữ kết luận bất chấp điều kiện.',
    'cửa điều kiện',
    'dấu điều kiện là bản lề giữa giả định và kết luận',
    'mẫu kia đổi mức chắc chắn hoặc đổi từ "nếu" sang "dù"',
    'điều kiện'),
  profile(/とおり|したがって|沿って|基づ|もと|通り/, '基準',
    'nhóm căn cứ nói hành động đi theo một bản mẫu, quy tắc, dữ liệu hoặc nguồn đã có.',
    'danh từ hoặc mệnh đề nguồn trước dấu căn cứ',
    'theo đúng nguồn/căn cứ',
    'Dùng khi câu cần bám vào hướng dẫn, kế hoạch, dữ liệu; đừng đọc như chỉ địa điểm.',
    'nguồn căn cứ',
    'mẫu căn cứ hỏi người nói bám theo cái gì',
    'mẫu kia có thể nói nguyên nhân hoặc phương tiện chứ không phải chuẩn để theo',
    'căn cứ'),
  profile(/について|に関して|に対して|にとって|として|向け|において|の下で|上で|上に|上は|以上/, '立場',
    'nhóm lập trường đặt danh từ làm chủ đề, đối tượng, vai trò, phạm vi hoặc điều kiện trách nhiệm.',
    'danh từ trước に/として/上',
    'phạm vi, vai trò, hoặc lập trường',
    'Dùng khi danh từ trước mẫu là điểm nhìn chính; phân biệt đối tượng bàn luận, đối tượng đối diện, và vai trò được gán.',
    'điểm nhìn danh từ',
    'mẫu lập trường hỏi câu đang nhìn từ vị trí nào',
    'mẫu kia thường đổi từ chủ đề sang đối tượng đối diện hoặc vai trò',
    'lập trường/phạm vi'),
  profile(/かかわらず|問わず|かまわず|関わって/, '無関係',
    'nhóm bất chấp loại điều kiện khỏi phép xét: có hay không, là ai, như thế nào thì kết luận vẫn chạy.',
    'danh từ hoặc mệnh đề điều kiện trước dấu bất chấp',
    'không phụ thuộc vào điều kiện',
    'Dùng trong quy định, thông báo, lập luận; を問わず nghiêng về "không xét", にかかわらず nghiêng về "không bị chi phối".',
    'điều kiện bị loại khỏi phép xét',
    'mẫu bất chấp gạt điều kiện sang bên',
    'mẫu kia có thể là nhượng bộ trong câu cụ thể hoặc phạm vi áp dụng rộng hơn',
    'bất kể'),
  profile(/通じて|通して|にわたって|かけて/, '範囲',
    'nhóm phạm vi trải nghĩa qua thời gian, không gian, phương tiện hoặc một quá trình trung gian.',
    'danh từ phạm vi trước dấu trải rộng',
    'xuyên qua hoặc trải khắp một phạm vi',
    'Dùng khi danh từ trước mẫu là kênh, khoảng thời gian, khu vực hoặc quá trình; tránh đọc thành địa điểm đơn lẻ.',
    'phạm vi trải rộng',
    'mẫu phạm vi hỏi ý nghĩa đi qua kênh/khoảng nào',
    'mẫu kia thường giới hạn vào điểm bắt đầu-kết thúc hoặc phương tiện khác',
    'phạm vi/kênh'),
  profile(/込めて|頼り|きっかけ|中心|はじめ|めぐ|反して|応えて|応じて|先立/, '関係',
    'nhóm quan hệ đặt danh từ làm tâm, nguồn khởi đầu, chỗ dựa, cảm xúc gửi vào, hoặc phản ứng theo yêu cầu.',
    'danh từ quan hệ trước を/に',
    'quan hệ chức năng giữa danh từ và hành động',
    'Dùng khi danh từ trước mẫu không phải tân ngữ thường mà là tâm điểm, căn cứ, cảm xúc, hoặc điều được đáp lại.',
    'quan hệ với danh từ trước mẫu',
    'mẫu quan hệ hỏi danh từ trước mẫu giữ vai gì',
    'mẫu kia có thể dùng cùng trợ từ nhưng đổi vai danh từ',
    'quan hệ chức năng'),
  profile(/一方|反面|ながら|つつ|つれて|ともなって|伴って/, '並行',
    'nhóm song song đặt hai ý cạnh nhau: đồng thời, đối lập hai mặt, hoặc một thay đổi kéo theo thay đổi khác.',
    'hai vế cùng tiến hoặc đối chiếu nhau',
    'diễn tiến song song hoặc đối lập hai mặt',
    'Dùng khi hai vế cùng tồn tại; nếu một vế chỉ là lý do cho vế kia, chuyển sang mẫu nguyên nhân.',
    'hai đường ý chạy song song',
    'mẫu song song buộc đọc cả hai vế cùng lúc',
    'mẫu kia có thể là nguyên nhân-kết quả thay vì song hành',
    'song hành/đối chiếu'),
  profile(/べき|ねば|はならない|まい|しかない|ほかない|ようがない|わけにはいかない|ことはない/, '義務',
    'nhóm nghĩa vụ/khả năng giới hạn lựa chọn của người nói: nên, không được, không thể, hoặc không còn cách khác.',
    'dạng động từ trước dấu nghĩa vụ/khả năng',
    'nghĩa vụ, cấm đoán, hoặc không còn lựa chọn',
    'Dùng khi câu nói về điều nên làm/không thể làm; xem nguồn ràng buộc là đạo lý, quy tắc hay hoàn cảnh.',
    'áp lực lựa chọn',
    'mẫu nghĩa vụ hỏi điều gì đang ép lựa chọn',
    'mẫu kia có thể mềm hơn, khách quan hơn, hoặc chỉ là khả năng',
    'nghĩa vụ/giới hạn'),
  profile(/すぎ|やすい|にくい|になる|にします|ている|てあります|てお|しまう|ちゃう|続ける|きる|抜く/, '変化',
    'nhóm biến đổi gắn vào thân động từ/tính từ để nói quá mức, dễ/khó, trạng thái, chuẩn bị, hoàn tất hoặc kéo dài.',
    'thân từ, te-form, hoặc dạng biến đổi trước trợ động từ',
    'trạng thái/kết quả/khả năng biến đổi',
    'Dùng khi phần sau động từ không còn là hành động mới mà là cách nhìn kết quả hoặc mức độ của hành động trước.',
    'dấu biến đổi sau thân từ',
    'mẫu biến đổi hỏi hành động đã đổi thành trạng thái gì',
    'mẫu kia thường đổi từ kết quả sang thói quen, chuẩn bị, hoặc cảm xúc',
    'biến đổi/trạng thái'),
  profile(/と思|と言|という|読みます|意味です|かどうか|疑問詞.*か|でしょう|かもしれ/, '引用',
    'nhóm trích dẫn/suy đoán dùng と hoặc か để đóng gói lời, ý nghĩ, câu hỏi, hoặc mức chắc chắn của người nói.',
    'mệnh đề thường trước と/か/でしょう',
    'nội dung được trích, hỏi gián tiếp, hoặc phỏng đoán',
    'Dùng khi cả câu trước mẫu là nội dung trong đầu/lời nói; kiểm tra だ với danh từ và tính từ na.',
    'nội dung được đóng gói',
    'mẫu trích dẫn hỏi câu nào là nội dung được đem ra nói',
    'mẫu kia có thể là truyền văn từ nguồn khác hoặc phỏng đoán mức khác',
    'nội dung/trích dẫn'),
  profile(/ない|た形|辞書|普通形|命令|意向|可能|形/, '活用',
    'nhóm chia thể đổi đuôi động từ/tính từ để tạo nền cho mẫu sau; bản thân đuôi đã mang phủ định, quá khứ, ý chí hoặc khả năng.',
    'đuôi chia thể của từ đứng trước',
    'dạng chia làm nền nghĩa',
    'Dùng như bước kiểm tra hình thái trước khi dịch; sai nhóm động từ sẽ kéo sai toàn bộ mẫu phía sau.',
    'đuôi chia thể',
    'mẫu chia thể hỏi từ đã được bẻ sang dạng nào',
    'mẫu kia có thể dùng cùng động từ nhưng đổi thời, phủ định hoặc thái độ',
    'dạng chia'),
];

function profile(re, anchor, root, formCue, meaning, usage, humanCue, signal, contrastCue, result) {
  return { re, anchor, root, formCue, meaning, usage, humanCue, signal, contrastCue, result };
}

function applyDirectiveERedo({
  contentRoot = path.join(process.cwd(), 'assets', 'data', 'content'),
  levels = ['n5', 'n4', 'n3', 'n2', 'n1'],
  write = false,
} = {}) {
  const grammarRoot = path.join(contentRoot, 'grammar');
  const candidatePatterns = readDirectiveEItems({ contentRoot })
    .map((entry) => entry.structure)
    .filter(Boolean)
    .slice(0, 40);
  const changed = [];
  const checked = [];

  for (const level of levels.map((value) => value.toLowerCase())) {
    const levelRoot = path.join(grammarRoot, level);
    if (!fs.existsSync(levelRoot)) continue;
    for (const file of fs.readdirSync(levelRoot).filter((name) => name.endsWith('.json')).sort(numericSort)) {
      const fullPath = path.join(levelRoot, file);
      const items = readJson(fullPath);
      if (!Array.isArray(items)) continue;
      let touched = false;
      const neighbors = items.map((item) => item.structure || item.title || '').filter(Boolean);
      const basename = path.basename(file, '.json');
      for (let index = 0; index < items.length; index += 1) {
        const item = items[index];
        const itemId = `grammar:${level}:${basename}:${String(index + 1).padStart(3, '0')}`;
        const report = validateDirectiveEItem(
          {
            item_id: itemId,
            label: item.title || item.structure || '',
            structure: item.structure || item.title || '',
            directiveE: item.directiveE,
          },
          { candidatePatterns },
        );
        checked.push({ itemId, passed: report.passed });
        if (report.passed) continue;
        item.directiveE = buildDirectiveE({
          item,
          level: level.toUpperCase(),
          neighborStructures: rotateNeighbors(neighbors, index),
        });
        touched = true;
        changed.push(itemId);
      }
      if (touched && write) {
        fs.writeFileSync(fullPath, `${JSON.stringify(items, null, 2)}\n`, 'utf8');
      }
    }
  }

  return {
    checked: checked.length,
    changed,
    changedCount: changed.length,
    wrote: write,
  };
}

function displayPattern(structure, title) {
  const preferred = clean(structure) || clean(title);
  return preferred.replace(/\s+/g, ' ').trim();
}

function kanjiBridge(pattern, profile) {
  const hints = [];
  if (/事|こと/.test(pattern)) hints.push('事 = sự, như "sự việc", giúp nhớ こと là cách biến hành động thành một chuyện để bàn.');
  if (/物|もの/.test(pattern)) hints.push('物 = vật, nhưng trong ngữ pháp thường mở rộng thành "bản chất/điều".');
  if (/様|よう/.test(pattern)) hints.push('様 = dạng/dáng, gần "hình dạng", nên よう hay nói về cách, vẻ hoặc mục tiêu.');
  if (/所|ところ/.test(pattern)) hints.push('所 = sở/chỗ, giúp nhớ ところ neo ý vào một điểm trong tiến trình.');
  if (/為|ため/.test(pattern)) hints.push('為 = vi, làm vì mục đích hoặc nguyên nhân; vì vậy ため thường nối lý do/mục tiêu.');
  if (/問/.test(pattern)) hints.push('問 = vấn/hỏi; trong 問わず, điều kiện bị gạt khỏi việc xét hỏi.');
  if (/込/.test(pattern)) hints.push('込 mang hình ảnh dồn vào bên trong; 込めて là gửi cảm xúc/ý định vào hành động.');
  if (/通/.test(pattern)) hints.push('通 = thông/qua; 通じて・通して giữ cảm giác đi xuyên qua một kênh hoặc phạm vi.');
  if (/基/.test(pattern)) hints.push('基 = cơ/nền; 基づいて là đặt lập luận trên nền căn cứ.');
  if (/応/.test(pattern)) hints.push('応 = ứng/đáp; 応じて・応えて đều gợi phản ứng theo yêu cầu hoặc tình huống.');
  if (hints.length > 0) {
    return `Cầu Hán-Việt: ${hints.join(' ')} Khi mẫu ${pattern} không hiện chữ Hán, vẫn đọc theo logic chức năng này để giảm tải ghi nhớ.`;
  }
  return `Cầu Hán-Việt: ${pattern} không có chữ Hán nổi bật để bám, nên mượn cặp ý "${profile.result} - dấu hiệu". Nhìn ${profile.signal} như ký hiệu chức năng báo ${profile.meaning}, không phải từ vựng riêng lẻ.`;
}

function japaneseAnchor(pattern, title) {
  const text = `${pattern} ${title}`;
  const preferred = [
    'いただけませんか', 'ことになる', 'ことにする', 'わけにはいかない',
    'かもしれません', 'にかかわらず', 'にもかかわらず', 'にしたがって',
    'にともなって', 'にほかならない', 'ではないか', 'なければなりません',
    'なくてもいい', 'てあります', 'ておきます', 'てしまう', 'てみます',
    'そうです', 'ようです', 'らしい', 'みたい', 'ばかり', 'ところ',
    'ために', 'ながら', 'として', 'について', 'に対して', 'に関して',
    '問わず', '通じて', '通して', '込めて', 'きっかけ', '中心',
    '一方', '反面', '以上', '以来', '際に', '折には', 'あげく',
    'べき', 'まい', 'もの', 'こと', 'わけ', 'はず', 'なら', 'ても',
    'たら', 'ば', 'と', 'か', 'に', 'で', 'を', 'が', 'は',
  ];
  const normalizedText = text.replace(/\s+/g, '');
  for (const token of preferred) {
    if (normalizedText.includes(token)) return token;
  }
  const match = text.match(/[\u3040-\u30ff\u3400-\u9fffー々〆〤]{1,12}/);
  return match ? match[0] : clean(pattern).slice(0, 24) || 'mẫu';
}

function meaningFromExplanation(explanation) {
  return clean(explanation)
    .replace(/`/g, '')
    .replace(/\s+/g, ' ')
    .replace(/^Dùng khi\s*/i, '')
    .slice(0, 140);
}

function firstUsefulNeighbor(neighborStructures, pattern) {
  const normalizedPattern = normalize(pattern);
  return neighborStructures
    .map((value) => clean(value))
    .filter(Boolean)
    .find((value) => normalize(value) !== normalizedPattern && /[\u3040-\u30ff\u3400-\u9fff]/.test(value));
}

function fallbackContrast(pattern) {
  if (/ことにする/.test(pattern)) return '〜ことになる';
  if (/ことになる|ことになっている/.test(pattern)) return '〜ことにする';
  if (/そう.*(だ|です)/.test(pattern)) return /語幹|stem|様態/.test(pattern) ? '普通形 + そうです（伝聞）' : 'Vます語幹 + そうです（様態）';
  if (/よう/.test(pattern)) return '〜みたいだ';
  if (/らしい|みたい/.test(pattern)) return '〜ようだ';
  if (/使役|させ/.test(pattern)) return '受身形';
  if (/受身|れる|られる/.test(pattern)) return '使役形';
  if (/尊敬|お \+|ご \+|になります/.test(pattern)) return '謙譲語';
  if (/謙譲|ございます|でございます/.test(pattern)) return '尊敬語';
  if (/てください|いただけませんか/.test(pattern)) return '〜てもいいですか';
  if (/んです/.test(pattern)) return '普通形だけの説明';
  if (/ため/.test(pattern)) return '〜ように';
  if (/ので|から/.test(pattern)) return '〜ために';
  if (/ば/.test(pattern)) return '〜たら';
  if (/たら/.test(pattern)) return '〜ば';
  if (/ても/.test(pattern)) return '〜のに';
  if (/なら/.test(pattern)) return '〜たら';
  if (/ところ/.test(pattern)) return '〜ばかり';
  if (/ばかり/.test(pattern)) return '〜ところ';
  if (/わけ/.test(pattern)) return '〜はずだ';
  if (/はず/.test(pattern)) return '〜わけだ';
  if (/もの/.test(pattern)) return '〜こと';
  if (/こと/.test(pattern)) return '〜もの';
  if (/問わず/.test(pattern)) return '〜にかかわらず';
  if (/かかわらず/.test(pattern)) return '〜を問わず';
  if (/通じて/.test(pattern)) return '〜を経て';
  if (/通して/.test(pattern)) return '〜を経て';
  if (/について|に関して/.test(pattern)) return '〜に対して';
  if (/に対して/.test(pattern)) return '〜について';
  if (/として/.test(pattern)) return '〜にとって';
  if (/ながら|つつ/.test(pattern)) return '〜間に';
  return '関連する近い文型';
}

function rotateNeighbors(values, index) {
  if (values.length === 0) return [];
  const out = [];
  for (let offset = 1; offset <= values.length; offset += 1) {
    out.push(values[(index + offset) % values.length]);
  }
  return out;
}

function firstSentence(value) {
  return clean(value).split(/\n|。|\./)[0]?.trim() || '';
}

function numericSort(left, right) {
  return numericSuffix(left) - numericSuffix(right) || left.localeCompare(right);
}

function numericSuffix(file) {
  const match = file.match(/_(\d+)\.json$/);
  return match ? Number(match[1]) : Number.MAX_SAFE_INTEGER;
}

function normalize(value) {
  return clean(value).normalize('NFKC').replace(/\s+/g, '').toLowerCase();
}

function clean(value) {
  return String(value || '').trim();
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function parseArgs(argv) {
  const args = { write: false, levels: undefined };
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === '--write') args.write = true;
    else if (argv[i] === '--levels') args.levels = argv[++i].split(',').map((value) => value.trim());
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv.slice(2));
  const report = applyDirectiveERedo(args);
  console.log(JSON.stringify(report, null, 2));
}

module.exports = {
  applyDirectiveERedo,
  buildDirectiveE,
};
