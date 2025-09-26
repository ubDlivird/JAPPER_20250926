//
//  TownEdit.swift
//  JAPPER
//
//  Created by SHUYA on 2025/09/19.
//

import SwiftUI

/// 都道府県関連の定数
// 変更: `townList`を`[Int: String]`のDictionaryに変更
public let townList: [Int: String] = [
    1: "北海道", 2: "青森県", 3: "岩手県", 4: "宮城県", 5: "秋田県",
    6: "山形県", 7: "福島県", 8: "茨城県", 9: "栃木県", 10: "群馬県",
    11: "埼玉県", 12: "千葉県", 13: "東京都", 14: "神奈川県", 15: "新潟県",
    16: "富山県", 17: "石川県", 18: "福井県", 19: "山梨県", 20: "長野県",
    21: "岐阜県", 22: "静岡県", 23: "愛知県", 24: "三重県", 25: "滋賀県",
    26: "京都府", 27: "大阪府", 28: "兵庫県", 29: "奈良県", 30: "和歌山県",
    31: "鳥取県", 32: "島根県", 33: "岡山県", 34: "広島県", 35: "山口県",
    36: "徳島県", 37: "香川県", 38: "愛媛県", 39: "高知県", 40: "福岡県",
    41: "佐賀県", 42: "長崎県", 43: "熊本県", 44: "大分県", 45: "宮崎県",
    46: "鹿児島県", 47: "沖縄県"
]

// MARK: - 北海道・東北地方
public let hokkaidoList: [String] = ["🐮"]   // 牛
public let aomoriList: [String] = ["🍏"]     // 青りんご
public let iwateList: [String] = ["🦪"]     // 牡蠣
public let miyagiList: [String] = ["🎋"]     // 七夕
public let akitaList: [String] = ["👹"]     // なまはげ
public let yamagataList: [String] = ["🍒"]    // さくらんぼ
public let fukushimaList: [String] = ["🎎"]   // だるま

// MARK: - 関東地方
public let ibarakiList: [String] = ["🍈"]     // メロン
public let tochigiList: [String] = ["🙉"]     // 見ざる
public let gunmaList: [String] = ["🐴"]     // 馬
public let saitamaList: [String] = ["🍘"]     // せんべい
public let chibaList: [String] = ["🥜"]     // ピーナッツ
public let tokyoList: [String] = ["🗼"]      // タワー
public let kanagawaList: [String] = ["🎡"]    // 遊園地

// MARK: - 中部地方
public let yamanashiList: [String] = ["🍇"]   // ぶどう
public let niigataList: [String] = ["🍙"]     // おにぎり
public let toyamaList: [String] = ["🍣"]     // 魚
public let ishikawaList: [String] = ["🏺"]     // 壺
public let fukuiList: [String] = ["🦀"]     // カニ
public let naganoList: [String] = ["🍎"]     // りんご
public let gifuList: [String] = ["🦆"]      // 鴨
public let shizuokaList: [String] = ["🍵"]     // お茶
public let aichiList: [String] = ["🚗"]     // 自動車
public let mieList: [String] = ["🦐"]      // エビ

// MARK: - 近畿地方
public let shigaList: [String] = ["🥷"]     // 忍者
public let kyotoList: [String] = ["👘"]     // 着物
public let osakaList: [String] = ["🐙"]     // たこやき
public let hyogoList: [String] = ["🏯"]     // 城
public let naraList: [String] = ["🫎"]      // 鹿
public let wakayamaList: [String] = ["🍊"]    // みかん

// MARK: - 中国・四国地方
public let tottoriList: [String] = ["🏜️"]    // 砂漠
public let shimaneList: [String] = ["⛩️"]    // 鳥居
public let okayamaList: [String] = ["🍡"]     // きびだんご
public let hiroshimaList: [String] = ["🍁"]    // 紅葉
public let yamaguchiList: [String] = ["🐡"]    // ふぐ
public let tokushimaList: [String] = ["🍥"]    // なると
public let kagawaList: [String] = ["🍜"]    // うどん
public let ehimeList: [String] = ["🍋"]    // レモン
public let kochiList: [String] = ["🐟"]    // 釣り

// MARK: - 九州・沖縄地方
public let fukuokaList: [String] = ["🏮"]     // 提灯
public let sagaList: [String] = ["🍽️"]       // 皿
public let nagasakiList: [String] = ["🌷"]    // チューリップ
public let kumamotoList: [String] = ["🐻"]     // 熊
public let oitaList: [String] = ["♨️"]      // 温泉
public let miyazakiList: [String] = ["🥭"]     // マンゴー
public let kagoshimaList: [String] = ["🌋"]    // 火山
public let okinawaList: [String] = ["🌺"]    // ハイビスカス

// MARK: - メソッド
/// 県番号に対応するリストを返すメソッド
/// @param townCode 県番号
/// @return 県番号に対応するStringの配列。存在しない場合は空の配列を返す。
public func getTownList(townCode: Int) -> [String] {
    switch townCode {
    case 1: // 北海道
        return hokkaidoList
    case 2: // 青森県
        return aomoriList
    case 3: // 岩手県
        return iwateList
    case 4: // 宮城県
        return miyagiList
    case 5: // 秋田県
        return akitaList
    case 6: // 山形県
        return yamagataList
    case 7: // 福島県
        return fukushimaList
    case 8: // 茨城県
        return ibarakiList
    case 9: // 栃木県
        return tochigiList
    case 10: // 群馬県
        return gunmaList
    case 11: // 埼玉県
        return saitamaList
    case 12: // 千葉県
        return chibaList
    case 13: // 東京都
        return tokyoList
    case 14: // 神奈川県
        return kanagawaList
    case 15: // 新潟県
        return niigataList
    case 16: // 富山県
        return toyamaList
    case 17: // 石川県
        return ishikawaList
    case 18: // 福井県
        return fukuiList
    case 19: // 山梨県
        return yamanashiList
    case 20: // 長野県
        return naganoList
    case 21: // 岐阜県
        return gifuList
    case 22: // 静岡県
        return shizuokaList
    case 23: // 愛知県
        return aichiList
    case 24: // 三重県
        return mieList
    case 25: // 滋賀県
        return shigaList
    case 26: // 京都府
        return kyotoList
    case 27: // 大阪府
        return osakaList
    case 28: // 兵庫県
        return hyogoList
    case 29: // 奈良県
        return naraList
    case 30: // 和歌山県
        return wakayamaList
    case 31: // 鳥取県
        return tottoriList
    case 32: // 島根県
        return shimaneList
    case 33: // 岡山県
        return okayamaList
    case 34: // 広島県
        return hiroshimaList
    case 35: // 山口県
        return yamaguchiList
    case 36: // 徳島県
        return tokushimaList
    case 37: // 香川県
        return kagawaList
    case 38: // 愛媛県
        return ehimeList
    case 39: // 高知県
        return kochiList
    case 40: // 福岡県
        return fukuokaList
    case 41: // 佐賀県
        return sagaList
    case 42: // 長崎県
        return nagasakiList
    case 43: // 熊本県
        return kumamotoList
    case 44: // 大分県
        return oitaList
    case 45: // 宮崎県
        return miyazakiList
    case 46: // 鹿児島県
        return kagoshimaList
    case 47: // 沖縄県
        return okinawaList
    default:
        return []
    }
}

/// 県番号から都道府県名を返すメソッド
/// @param code 県番号
/// @return 都道府県名。県番号が不正な場合は空文字列を返す。
public func CountyCodeToName(code: Int) -> String {
    return townList[code] ?? ""
}
