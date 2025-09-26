//
//  ProfileEditView.swift
//  JAPPER
//
//  Created by SHUYA on 2025/09/19.
//

import SwiftUI

/// UserDefaultsに保存するキー
private let userDefaultsKey = "UserData"

struct ProfileEditView: View {

    // MARK: - 編集対象のプロパティをBindingで受け取る
    // ProfileViewから渡される状態を直接変更するためにBindingを使用
    @Binding var profileImageName: String
    @Binding var userName: String
    @Binding var bio: String
    // 変更: 推し都道府県をInt型でBindingで受け取る
    @Binding var favoriteTown: Int
    
    // MARK: - 新規追加: 編集前のデータを保持するプロパティ
    private let initialProfileImageName: String
    private let initialUserName: String
    private let initialBio: String
    // 変更: initialFavoriteTownをInt型で保持
    private let initialFavoriteTown: Int
    
    // MARK: - 新規追加: ビューの表示を制御する環境変数
    @Environment(\.dismiss) var dismiss
    
    /// イニシャライザ
    /// @param profileImageName プロフィール画像名
    /// @param userName ユーザーネーム
    /// @param bio 自己紹介文
    /// @param favoriteTown 推し都道府県
    init(profileImageName: Binding<String>, userName: Binding<String>, bio: Binding<String>, favoriteTown: Binding<Int>) {
        // MARK: 既存のプロパティへのバインディングを設定
        _profileImageName = profileImageName
        _userName = userName
        _bio = bio
        _favoriteTown = favoriteTown
        
        // MARK: 編集前の初期値を保存
        self.initialProfileImageName = profileImageName.wrappedValue
        self.initialUserName = userName.wrappedValue
        self.initialBio = bio.wrappedValue
        self.initialFavoriteTown = favoriteTown.wrappedValue
    }
    
    // MARK: - ビューの表示
    var body: some View {
        // Formコンテナで入力を整理
        Form {
            // プロフィール画像の編集セクション
            Section(header: Text("プロフィール画像")) {
                // 変更: TextFieldからPickerに変更して絵文字を選択可能にする
                // 変更: 推し都道府県で選択したリストを表示するように変更
                Picker("絵文字を選択", selection: $profileImageName) {
                    // getTownListメソッドから、選択された都道府県に対応するリストを取得
                    ForEach(getTownList(townCode: favoriteTown), id: \.self) { emoji in
                        Text(emoji)
                            .tag(emoji)
                    }
                }
            }
            
            // 新規: 推し都道府県の編集セクション
            Section(header: Text("推し都道府県")) {
                // TownEdit.swiftで定義した都道府県のリストから選択できるPicker
                Picker("都道府県を選択", selection: $favoriteTown) {
                    // 変更: townListのキーと値をループ
                    ForEach(townList.sorted(by: <), id: \.key) { key, value in
                        // 修正: 絵文字と都道府県名を結合して表示
                        Text("\(getTownList(townCode: key).first ?? "") \(value)").tag(key)
                    }
                }
                // MARK: 新規: 都道府県選択時にプロフィール画像を自動更新する
                // `favoriteTown`が変更された際に`profileImageName`を更新する
                .onChange(of: favoriteTown) { newTownCode in
                    // 変更された都道府県に対応するリストを取得
                    if let firstEmoji = getTownList(townCode: newTownCode).first {
                        profileImageName = firstEmoji
                    }
                }
            }
            
            // ユーザーネームの編集セクション
            Section(header: Text("ユーザーネーム")) {
                // ユーザーネームを編集するためのテキストフィールド
                TextField("ユーザーネーム", text: $userName)
            }
            
            // 自己紹介の編集セクション
            Section(header: Text("自己紹介")) {
                // 自己紹介を複数行で編集するためのTextEditor
                TextEditor(text: $bio)
                    .frame(minHeight: 100, maxHeight: 200) // 最小・最大高さを設定
            }
        }
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: 修正: .onDisappearからツールバーボタンによる制御へ変更
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                // キャンセルボタン
                Button("保存せず戻る") {
                    // MARK: 変更前の値に戻す
                    profileImageName = initialProfileImageName
                    userName = initialUserName
                    bio = initialBio
                    favoriteTown = initialFavoriteTown
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                // 保存ボタン
                Button("保存") {
                    saveUserProfile()
                    dismiss()
                }
            }
        }
        // MARK: 新規: ビューが表示された際に初期値を設定
        .onAppear {
            if let firstEmoji = getTownList(townCode: initialFavoriteTown).first {
                profileImageName = firstEmoji
            }
        }
    }
    
    // MARK: - メソッド
    /// ユーザープロフィールをUserDefaultsに保存するメソッド
    private func saveUserProfile() {
        // 変更されたデータをUser構造体に格納
        let user = User(
            profileImageName: profileImageName,
            favoriteTown: favoriteTown,
            userName: userName,
            bio: bio
        )
        
        do {
            // MARK: デバッグログの追加
            print("ユーザープロフィールを保存します: \(user)")
            
            // User構造体をJSONデータにエンコード
            let encodedData = try JSONEncoder().encode(user)
            // UserDefaultsに保存
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            print("ユーザープロフィールを保存しました。")
        } catch {
            print("ユーザープロフィールの保存に失敗しました: \(error)")
        }
    }
}
