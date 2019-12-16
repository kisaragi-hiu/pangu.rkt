#lang racket/base

;; ported from https://github.com/vinta/pangu.py/blob/master/test_pangu.py

(require pangu
         rackunit)

(module+ test
  ;; 略過
  (test-case "skip underscore"
             (check-equal? (spacing "前面_後面") "前面_後面")
             (check-equal? (spacing "前面 _ 後面") "前面 _ 後面")
             (check-equal? (spacing "Vinta_Mollie") "Vinta_Mollie")
             (check-equal? (spacing "Vinta _ Mollie") "Vinta _ Mollie"))
  ;; 兩邊都加空格
  (test-case "alphabets"
             (check-equal? (spacing "中文abc") "中文 abc")
             (check-equal? (spacing "abc中文") "abc 中文"))
  (test-case "numbers"
             (check-equal? (spacing "中文123") "中文 123")
             (check-equal? (spacing "123中文") "123 中文"))
  (test-case "latin1_supplement"
             (check-equal? (spacing "中文Ø漢字") "中文 Ø 漢字")
             (check-equal? (spacing "中文 Ø 漢字") "中文 Ø 漢字"))
  (test-case "greek_and_coptic"
             (check-equal? (spacing "中文β漢字") "中文 β 漢字")
             (check-equal? (spacing "中文 β 漢字") "中文 β 漢字")
             (check-equal? (spacing "我是α，我是Ω") "我是 α，我是 Ω"))
  (test-case "number_forms"
             (check-equal? (spacing "中文Ⅶ漢字") "中文 Ⅶ 漢字")
             (check-equal? (spacing "中文 Ⅶ 漢字") "中文 Ⅶ 漢字"))
  (test-case "cjk_radicals_supplement"
             (check-equal? (spacing "abc⻤123") "abc ⻤ 123")
             (check-equal? (spacing "abc ⻤ 123") "abc ⻤ 123"))
  (test-case "kangxi_radicals"
             (check-equal? (spacing "abc⾗123") "abc ⾗ 123")
             (check-equal? (spacing "abc ⾗ 123") "abc ⾗ 123"))
  (test-case "hiragana"
             (check-equal? (spacing "abcあ123") "abc あ 123")
             (check-equal? (spacing "abc あ 123") "abc あ 123"))
  (test-case "katakana"
             (check-equal? (spacing "abcア123") "abc ア 123")
             (check-equal? (spacing "abc ア 123") "abc ア 123"))
  (test-case "bopomofo"
             (check-equal? (spacing "abcㄅ123") "abc ㄅ 123")
             (check-equal? (spacing "abc ㄅ 123") "abc ㄅ 123"))
  (test-case "enclosed_cjk_letters_and_months"
             (check-equal? (spacing "abc㈱123") "abc ㈱ 123")
             (check-equal? (spacing "abc ㈱ 123") "abc ㈱ 123"))
  (test-case "cjk_unified_ideographs_extension_a"
             (check-equal? (spacing "abc㐂123") "abc 㐂 123")
             (check-equal? (spacing "abc 㐂 123") "abc 㐂 123"))
  (test-case "cjk_unified_ideographs"
             (check-equal? (spacing "abc丁123") "abc 丁 123")
             (check-equal? (spacing "abc 丁 123") "abc 丁 123"))
  (test-case "cjk_compatibility_ideographs"
             (check-equal? (spacing "abc車123") "abc 車 123")
             (check-equal? (spacing "abc 車 123") "abc 車 123"))
  (test-case "dollar"
             (check-equal? (spacing "前面$後面") "前面 $ 後面")
             (check-equal? (spacing "前面 $ 後面") "前面 $ 後面")
             (check-equal? (spacing "前面$100後面") "前面 $100 後面"))
  (test-case "percent"
             (check-equal? (spacing "前面%後面") "前面 % 後面")
             (check-equal? (spacing "前面 % 後面") "前面 % 後面")
             (check-equal? (spacing "前面100%後面") "前面 100% 後面")
             (check-equal? (spacing "新八的構造成分有95%是眼鏡、3%是水、2%是垃圾") "新八的構造成分有 95% 是眼鏡、3% 是水、2% 是垃圾"))
  (test-case "caret"
             (check-equal? (spacing "前面^後面") "前面 ^ 後面")
             (check-equal? (spacing "前面 ^ 後面") "前面 ^ 後面"))
  (test-case "ampersand"
             (check-equal? (spacing "前面&後面") "前面 & 後面")
             (check-equal? (spacing "前面 & 後面") "前面 & 後面")
             (check-equal? (spacing "Vinta&Mollie") "Vinta&Mollie")
             (check-equal? (spacing "Vinta&陳上進") "Vinta & 陳上進")
             (check-equal? (spacing "陳上進&Vinta") "陳上進 & Vinta")
             (check-equal? (spacing "得到一個A&B的結果") "得到一個 A&B 的結果"))
  (test-case "asterisk"
             (check-equal? (spacing "前面*後面") "前面 * 後面")
             (check-equal? (spacing "前面 * 後面") "前面 * 後面")
             (check-equal? (spacing "Vinta*Mollie") "Vinta*Mollie")
             (check-equal? (spacing "Vinta*陳上進") "Vinta * 陳上進")
             (check-equal? (spacing "陳上進*Vinta") "陳上進 * Vinta")
             (check-equal? (spacing "得到一個A*B的結果") "得到一個 A*B 的結果"))
  (test-case "minus"
             (check-equal? (spacing "前面-後面") "前面 - 後面")
             (check-equal? (spacing "前面 - 後面") "前面 - 後面")
             (check-equal? (spacing "Vinta-Mollie") "Vinta-Mollie")
             (check-equal? (spacing "Vinta-陳上進") "Vinta - 陳上進")
             (check-equal? (spacing "陳上進-Vinta") "陳上進 - Vinta")
             (check-equal? (spacing "得到一個A-B的結果") "得到一個 A-B 的結果")
             (check-equal? (spacing "长者的智慧和复杂的维斯特洛- 文章") "长者的智慧和复杂的维斯特洛 - 文章"))
  (test-case "equal"
             (check-equal? (spacing "前面=後面") "前面 = 後面")
             (check-equal? (spacing "前面 = 後面") "前面 = 後面")
             (check-equal? (spacing "Vinta=Mollie") "Vinta=Mollie")
             (check-equal? (spacing "Vinta=陳上進") "Vinta = 陳上進")
             (check-equal? (spacing "陳上進=Vinta") "陳上進 = Vinta")
             (check-equal? (spacing "得到一個A=B的結果") "得到一個 A=B 的結果"))
  (test-case "plus"
             (check-equal? (spacing "前面+後面") "前面 + 後面")
             (check-equal? (spacing "前面 + 後面") "前面 + 後面")
             (check-equal? (spacing "Vinta+Mollie") "Vinta+Mollie")
             (check-equal? (spacing "Vinta+陳上進") "Vinta + 陳上進")
             (check-equal? (spacing "陳上進+Vinta") "陳上進 + Vinta")
             (check-equal? (spacing "得到一個A+B的結果") "得到一個 A+B 的結果")
             (check-equal? (spacing "得到一個C++的結果") "得到一個 C++ 的結果"))
  (test-case "pipe"
             (check-equal? (spacing "前面|後面") "前面 | 後面")
             (check-equal? (spacing "前面 | 後面") "前面 | 後面")
             (check-equal? (spacing "Vinta|Mollie") "Vinta|Mollie")
             (check-equal? (spacing "Vinta|陳上進") "Vinta | 陳上進")
             (check-equal? (spacing "陳上進|Vinta") "陳上進 | Vinta")
             (check-equal? (spacing "得到一個A|B的結果") "得到一個 A|B 的結果"))
  ;; Currently (spacing "前面\\後面") hangs.
  ;; (test-case "backslash"
  ;;            (check-equal? (spacing "前面\\後面") "前面 \\ 後面")
  ;;            (check-equal? (spacing "前面 \\ 後面") "前面 \\ 後面")))
  (test-case "slash"
             (check-equal? (spacing "前面/後面") "前面 / 後面")
             (check-equal? (spacing "前面 / 後面") "前面 / 後面")
             (check-equal? (spacing "Vinta/Mollie") "Vinta/Mollie")
             (check-equal? (spacing "Vinta/陳上進") "Vinta / 陳上進")
             (check-equal? (spacing "陳上進/Vinta") "陳上進 / Vinta")
             (check-equal? (spacing "Mollie/陳上進/Vinta") "Mollie / 陳上進 / Vinta")
             (check-equal? (spacing "得到一個A/B的結果") "得到一個 A/B 的結果")
             (check-equal? (spacing "2016-12-26(奇幻电影节) / 2017-01-20(美国) / 詹姆斯麦卡沃伊") "2016-12-26 (奇幻电影节) / 2017-01-20 (美国) / 詹姆斯麦卡沃伊")
             (check-equal? (spacing "/home/和/root是Linux中的頂級目錄") "/home/ 和 /root 是 Linux 中的頂級目錄")
             (check-equal? (spacing "當你用cat和od指令查看/dev/random和/dev/urandom的內容時") "當你用 cat 和 od 指令查看 /dev/random 和 /dev/urandom 的內容時"))
  (test-case "less_than"
             (check-equal? (spacing "前面<後面") "前面 < 後面")
             (check-equal? (spacing "前面 < 後面") "前面 < 後面")
             (check-equal? (spacing "Vinta<Mollie") "Vinta<Mollie")
             (check-equal? (spacing "Vinta<陳上進") "Vinta < 陳上進")
             (check-equal? (spacing "陳上進<Vinta") "陳上進 < Vinta")
             (check-equal? (spacing "得到一個A<B的結果") "得到一個 A<B 的結果"))
  (test-case "greater_than"
             (check-equal? (spacing "前面>後面") "前面 > 後面")
             (check-equal? (spacing "前面 > 後面") "前面 > 後面")
             (check-equal? (spacing "Vinta>Mollie") "Vinta>Mollie")
             (check-equal? (spacing "Vinta>陳上進") "Vinta > 陳上進")
             (check-equal? (spacing "陳上進>Vinta") "陳上進 > Vinta")
             (check-equal? (spacing "得到一個A>B的結果") "得到一個 A>B 的結果")
             (check-equal? (spacing "得到一個A>B的結果") "得到一個 A>B 的結果"))
  ;; 只加左空格
  (test-case "at"
             ;; https://twitter.com/vinta
             ;; https://www.weibo.com/vintalines
             (check-equal? (spacing "請@vinta吃大便") "請 @vinta 吃大便")
             (check-equal? (spacing "請@陳上進 吃大便") "請 @陳上進 吃大便"))
  (test-case "hash"
             (check-equal? (spacing "前面#後面") "前面 #後面")
             (check-equal? (spacing "前面C#後面") "前面 C# 後面")
             (check-equal? (spacing "前面#H2G2後面") "前面 #H2G2 後面")
             (check-equal? (spacing "前面 #銀河便車指南 後面") "前面 #銀河便車指南 後面")
             (check-equal? (spacing "前面#銀河便車指南 後面") "前面 #銀河便車指南 後面")
             (check-equal? (spacing "前面#銀河公車指南 #銀河拖吊車指南 後面") "前面 #銀河公車指南 #銀河拖吊車指南 後面"))
  ;; 只加右空格
  (test-case "triple_dot"
             (check-equal? (spacing "前面...後面") "前面... 後面")
             (check-equal? (spacing "前面..後面") "前面.. 後面"))
  (test-case "u2026"
             (check-equal? (spacing "前面…後面") "前面… 後面")
             (check-equal? (spacing "前面……後面") "前面…… 後面"))
  ;; 換成全形符號
  (test-case "tilde"
             (check-equal? (spacing "前面~後面") "前面～後面")
             (check-equal? (spacing "前面 ~ 後面") "前面～後面")
             (check-equal? (spacing "前面~ 後面") "前面～後面")
             (check-equal? (spacing "前面 ~後面") "前面～後面"))
  (test-case "exclamation_mark"
             (check-equal? (spacing "前面!後面") "前面！後面")
             (check-equal? (spacing "前面 ! 後面") "前面！後面")
             (check-equal? (spacing "前面! 後面") "前面！後面")
             (check-equal? (spacing "前面 !後面") "前面！後面"))
  (test-case "semicolon"
             (check-equal? (spacing "前面;後面") "前面；後面")
             (check-equal? (spacing "前面 ; 後面") "前面；後面")
             (check-equal? (spacing "前面; 後面") "前面；後面")
             (check-equal? (spacing "前面 ;後面") "前面；後面"))
  (test-case "colon"
             (check-equal? (spacing "前面:後面") "前面：後面")
             (check-equal? (spacing "前面 : 後面") "前面：後面")
             (check-equal? (spacing "前面: 後面") "前面：後面")
             (check-equal? (spacing "前面 :後面") "前面：後面")
             (check-equal? (spacing "電話:123456789") "電話：123456789")
             (check-equal? (spacing "前面:)後面") "前面：) 後面")
             (check-equal? (spacing "前面:I have no idea後面") "前面：I have no idea 後面")
             (check-equal? (spacing "前面: I have no idea後面") "前面: I have no idea 後面"))
  (test-case "comma"
             (check-equal? (spacing "前面,後面") "前面，後面")
             (check-equal? (spacing "前面 , 後面") "前面，後面")
             (check-equal? (spacing "前面, 後面") "前面，後面")
             (check-equal? (spacing "前面 ,後面") "前面，後面")
             (check-equal? (spacing "前面,") "前面，")
             (check-equal? (spacing "前面, ") "前面，"))
  (test-case "period"
             (check-equal? (spacing "前面.後面") "前面。後面")
             (check-equal? (spacing "前面 . 後面") "前面。後面")
             (check-equal? (spacing "前面. 後面") "前面。後面")
             (check-equal? (spacing "前面 .後面") "前面。後面")
             (check-equal? (spacing "黑人問號.jpg 後面") "黑人問號.jpg 後面"))
  (test-case "question_mark"
             (check-equal? (spacing "前面?後面") "前面？後面")
             (check-equal? (spacing "前面 ? 後面") "前面？後面")
             (check-equal? (spacing "前面? 後面") "前面？後面")
             (check-equal? (spacing "前面 ?後面") "前面？後面")
             (check-equal? (spacing "所以，請問Jackey的鼻子有幾個?3.14個") "所以，請問 Jackey 的鼻子有幾個？3.14 個"))
  (test-case "u00b7"
             (check-equal? (spacing "前面·後面") "前面・後面")
             (check-equal? (spacing "喬治·R·R·馬丁") "喬治・R・R・馬丁")
             (check-equal? (spacing "M·奈特·沙马兰") "M・奈特・沙马兰"))
  (test-case "u2022"
             (check-equal? (spacing "前面•後面") "前面・後面")
             (check-equal? (spacing "喬治•R•R•馬丁") "喬治・R・R・馬丁")
             (check-equal? (spacing "M•奈特•沙马兰") "M・奈特・沙马兰"))
  (test-case "u2027"
             (check-equal? (spacing "前面‧後面") "前面・後面")
             (check-equal? (spacing "喬治‧R‧R‧馬丁") "喬治・R・R・馬丁")
             (check-equal? (spacing "M‧奈特‧沙马兰") "M・奈特・沙马兰"))
  ;; 成對符號：相異
  (test-case "less_than_and_greater_than"
             (check-equal? (spacing "前面<中文123漢字>後面") "前面 <中文 123 漢字> 後面")
             (check-equal? (spacing "前面<中文123>後面") "前面 <中文 123> 後面")
             (check-equal? (spacing "前面<123漢字>後面") "前面 <123 漢字> 後面")
             (check-equal? (spacing "前面<中文123漢字> tail") "前面 <中文 123 漢字> tail")
             (check-equal? (spacing "head <中文123漢字>後面") "head <中文 123 漢字> 後面")
             (check-equal? (spacing "head <中文123漢字> tail") "head <中文 123 漢字> tail"))
  (test-case "parentheses"
             (check-equal? (spacing "前面(中文123漢字)後面") "前面 (中文 123 漢字) 後面")
             (check-equal? (spacing "前面(中文123)後面") "前面 (中文 123) 後面")
             (check-equal? (spacing "前面(123漢字)後面") "前面 (123 漢字) 後面")
             (check-equal? (spacing "前面(中文123) tail") "前面 (中文 123) tail")
             (check-equal? (spacing "head (中文123漢字)後面") "head (中文 123 漢字) 後面")
             (check-equal? (spacing "head (中文123漢字) tail") "head (中文 123 漢字) tail")
             (check-equal? (spacing "(or simply \"React\")") "(or simply \"React\")")
             (check-equal? (spacing "OperationalError: (2006, 'MySQL server has gone away')")
                           "OperationalError: (2006, 'MySQL server has gone away')")
             (check-equal? (spacing "我看过的电影(1404)") "我看过的电影 (1404)")
             (check-equal? (spacing "Chang Stream(变更记录流)是指collection(数据库集合)的变更事件流") "Chang Stream (变更记录流) 是指 collection (数据库集合) 的变更事件流"))
  (test-case "braces"
             (check-equal? (spacing "前面{中文123漢字}後面") "前面 {中文 123 漢字} 後面")
             (check-equal? (spacing "前面{中文123}後面") "前面 {中文 123} 後面")
             (check-equal? (spacing "前面{123漢字}後面") "前面 {123 漢字} 後面")
             (check-equal? (spacing "前面{中文123漢字} tail") "前面 {中文 123 漢字} tail")
             (check-equal? (spacing "head {中文123漢字}後面") "head {中文 123 漢字} 後面")
             (check-equal? (spacing "head {中文123漢字} tail") "head {中文 123 漢字} tail"))
  (test-case "brackets"
             (check-equal? (spacing "前面[中文123漢字]後面") "前面 [中文 123 漢字] 後面")
             (check-equal? (spacing "前面[中文123]後面") "前面 [中文 123] 後面")
             (check-equal? (spacing "前面[123漢字]後面") "前面 [123 漢字] 後面")
             (check-equal? (spacing "前面[中文123漢字] tail") "前面 [中文 123 漢字] tail")
             (check-equal? (spacing "head [中文123漢字]後面") "head [中文 123 漢字] 後面")
             (check-equal? (spacing "head [中文123漢字] tail") "head [中文 123 漢字] tail"))
  (test-case "u201c_u201d"
             (check-equal? (spacing "前面“中文123漢字”後面") "前面 “中文 123 漢字” 後面"))
  ;; 成對符號：相同
  (test-case "back_quote_back_quote"
             (check-equal? (spacing "前面`中間`後面") "前面 `中間` 後面"))
  (test-case "hash_hash"
             (check-equal? (spacing "前面#H2G2#後面") "前面 #H2G2# 後面")
             (check-equal? (spacing "前面#銀河閃電霹靂車指南#後面") "前面 #銀河閃電霹靂車指南# 後面"))
  (test-case "quote_quote"
             (check-equal? (spacing "前面\"中文123漢字\"後面") "前面 \"中文 123 漢字\" 後面")
             (check-equal? (spacing "前面\"中文123\"後面") "前面 \"中文 123\" 後面")
             (check-equal? (spacing "前面\"123漢字\"後面") "前面 \"123 漢字\" 後面")
             (check-equal? (spacing "前面\"中文123\" tail") "前面 \"中文 123\" tail")
             (check-equal? (spacing "head \"中文123漢字\"後面") "head \"中文 123 漢字\" 後面")
             (check-equal? (spacing "head \"中文123漢字\" tail") "head \"中文 123 漢字\" tail"))
  (test-case "single_quote_single_quote"
             (check-equal? (spacing "Why are Python's 'private' methods not actually private?") "Why are Python's 'private' methods not actually private?")
             (check-equal? (spacing "陳上進 likes 林依諾's status.") "陳上進 likes 林依諾's status.")
             (check-equal? (spacing "举个栗子，如果一道题只包含'A' ~ 'Z'意味着字符集大小是") "举个栗子，如果一道题只包含 'A' ~ 'Z' 意味着字符集大小是"))
  (test-case "u05f4_u05f4"
             (check-equal? (spacing "前面״中間״後面") "前面 ״中間״ 後面"))
  ;; 英文與符號
  (test-case "alphabets_u201c_u201d"
             (check-equal? (spacing "阿里云开源“计算王牌”Blink，实时计算时代已来") "阿里云开源 “计算王牌” Blink，实时计算时代已来")
             (check-equal? (spacing "苹果撤销Facebook“企业证书”后者股价一度短线走低") "苹果撤销 Facebook “企业证书” 后者股价一度短线走低")
             (check-equal? (spacing "【UCG中字】“數毛社”DF的《戰神4》全新演示解析") "【UCG 中字】“數毛社” DF 的《戰神 4》全新演示解析"))
  (test-case "parentheses_percent"
             (check-equal? (spacing "丹寧控注意Levi's全館任2件25%OFF滿額再享85折！") "丹寧控注意 Levi's 全館任 2 件 25% OFF 滿額再享 85 折！"))
  (test-case "spacing_text"
             (check-equal? (spacing-text "請使用uname -m指令來檢查你的Linux作業系統是32位元或是[敏感词已被屏蔽]位元") "請使用 uname -m 指令來檢查你的 Linux 作業系統是 32 位元或是 [敏感词已被屏蔽] 位元")))
