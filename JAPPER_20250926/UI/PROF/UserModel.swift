//
//  UserModel.swift
//  JAPPER
//
//  Created by SHUYA on 2025/09/19.
//

import Foundation

/// ユーザーデータを保持する構造体
/// `Codable`に準拠させることで、データ（JSONなど）への変換を可能にする
struct User: Codable {
    var profileImageName: String
    var favoriteTown: Int // 変更: 推し都道府県をInt型で管理
    var userName: String
    var bio: String
}
