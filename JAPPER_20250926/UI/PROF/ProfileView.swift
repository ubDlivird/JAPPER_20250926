//
//  ProfileView.swift
//  JAPPER
//
//  Created by SHUYA on 2025/09/18.
//

import SwiftUI

/// UserDefaultsからユーザーデータを読み込むためのキー
private let userDefaultsKey = "UserData"

// MARK: - 定数
private let defaultProfileImageName = "person.circle.fill"
private let defaultFavoriteTown = 29 // 変更: 初期値を奈良県の県番号（29）に変更
private let defaultUserName = "ウーバー配達員"
private let defaultBio = "ゲームとガジェットをこよなく愛するiOS開発者です。SwiftUIで直感的で美しいUIを創ることに喜びを感じます。日々、技術の進化を追いながら、自作ゲームのリリースを目指しています。皆さんの好きなゲームをぜひ教えてください。"
private let defaultUserId = "user_id_001"
private let defaultRegistrationDate = "2025年9月18日"

struct ProfileView: View {
    // ユーザー情報を保持するためのサンプルデータ
    // MARK: 変更: 起動時の初期値を空の文字列に変更
    @State private var profileImageName = ""
    @State private var favoriteTown = 0 // 変更: Int型に変更し、初期値を0に
    @State private var friendCount = 123
    @State private var likeCount = 456
    @State private var userName = ""
    @State private var userId = defaultUserId
    @State private var registrationDate = defaultRegistrationDate
    @State private var bio = ""

    var body: some View {
        // ナビゲーションビューで画面全体をラップ
        NavigationView {
            // 垂直方向のレイアウト
            VStack(spacing: 5) {
                // MARK: プロフィール概要エリア
                // GeometryReader を使用して画面を均等に3分割し、それぞれの要素を中央に配置
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 0) {
                        // プロフィール画像エリア
                        VStack {
                            // 修正: ハードコードされた絵文字を状態変数 profileImageName に変更
                            Text(profileImageName)
                                .font(.system(size: 80)) // フォントサイズを大きくして絵文字を拡大
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .center)
                                .background(Circle().fill(Color.gray.opacity(0.2))) // 新規: 背景色を付けることで円形を強調
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2)) // 新規: 白い枠線を追加
                        }
                        .frame(width: geometry.size.width / 3) // 画面幅を3で割った幅を設定

                        // 推しエリア
                        VStack {
                            // 変更: CountyCodeToNameを呼び出して県番号から県名を取得
                            Text(CountyCodeToName(code: favoriteTown))
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("推し")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: geometry.size.width / 3) // 画面幅を3で割った幅を設定

                        // いいねエリア
                        VStack {
                            Text("\(likeCount)")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("いいね")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: geometry.size.width / 3) // 画面幅を3で割った幅を設定
                    }
                }
                .frame(height: 90) // GeometryReaderに高さを与える
                .background(Color.red.opacity(0.2)) // 新規: プロフィール概要エリアの背景色
                
                // MARK: ユーザー情報エリア
                 VStack(alignment: .leading, spacing: 5) {
                     // ユーザーネーム
                     Text(userName)
                         .font(.title3)
                         .fontWeight(.bold)
                     
                     // ユーザーID
                     Text("@\(userId)")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     
                     // 登録日
                     Text("登録日: \(registrationDate)")
                         .font(.subheadline)
                         .foregroundColor(.secondary)
                 }
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding(.horizontal)
                 .background(Color.green.opacity(0.2)) // 新規: ユーザー情報エリアの背景色
                
                // MARK: 自由記入欄エリア
                VStack(alignment: .leading, spacing: 5) {
                    Text(bio)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .background(Color.blue.opacity(0.2)) // 新規: 自由記入欄エリアの背景色
                
                Spacer()
            }
            .navigationTitle("プロフィール") // ナビゲーションバーのタイトル
            .navigationBarTitleDisplayMode(.inline) // タイトルをインライン表示にしてナビゲーションバーを薄くする
            .toolbar {
                // MARK: ナビゲーションバー右側に編集ボタンを配置
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfileEditView(profileImageName: $profileImageName, userName: $userName, bio: $bio, favoriteTown: $favoriteTown)
                    } label: {
                        Image(systemName: "pencil.line")
                    }
                }
            }
            .onAppear {
                loadUserProfile() // ビューが表示される際にユーザープロフィールを読み込む
            }
        }
    }
    
    // MARK: - メソッド
    /// UserDefaultsからユーザープロフィールを読み込むメソッド
    private func loadUserProfile() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                // 保存されたJSONデータをUser構造体にデコード
                let decodedUser = try JSONDecoder().decode(User.self, from: savedData)
                // 読み込んだデータで@Stateプロパティを更新
                self.profileImageName = decodedUser.profileImageName
                self.userName = decodedUser.userName
                self.bio = decodedUser.bio
                self.favoriteTown = decodedUser.favoriteTown
                
                // MARK: デバッグログの追加
                print("ユーザープロフィールを読み込みました: \(decodedUser)")
            } catch {
                print("ユーザープロフィールの読み込みに失敗しました: \(error)")
            }
        } else {
            // 新規: 保存データがない場合の初期値を定数で設定
            self.profileImageName = defaultProfileImageName
            self.favoriteTown = defaultFavoriteTown
            self.userName = defaultUserName
            self.bio = defaultBio
            
            // MARK: デバッグログの追加
            print("保存データが見つかりませんでした。初期値を設定しました。")
        }
    }
}
