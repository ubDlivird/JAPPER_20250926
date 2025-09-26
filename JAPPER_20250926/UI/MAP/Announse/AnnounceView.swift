// MARK: - AnnounceView
import SwiftUI

struct AnnounceView: View {
    // アプリケーションロジックに関する定数
    private let maxAnnounceCount = 5 // アナウンスの最大表示件数
    private let announceRemovalDelay: TimeInterval = 7.0 // アナウンスが自動で消えるまでの時間
    
    // UIレイアウトに関する定数
    private let buttonSpacing: CGFloat = 20 // ボタン間のスペース
    private let announceAreaMaxWidth: CGFloat = 150 // アナウンス表示エリアの最大幅
    private let announceAreaMaxHeight: CGFloat = 150 // アナウンス表示エリアの最大高さ
    private let announcePaddingHorizontal: CGFloat = 5 // アナウンスメッセージの左右余白
    private let announcePaddingVertical: CGFloat = 5 // アナウンスメッセージの上下余白
    private let cornerRadius: CGFloat = 10 // 角丸の半径
    private let announceAreaPadding: CGFloat = 10 // アナウンスエリアの内側余白
    private let announceAreaTopPadding: CGFloat = 10 // アナウンスエリアの上部余白
    private let announceAreaTrailingPadding: CGFloat = 10 // アナウンスエリアの右部余白
    private let announceFontSize: CGFloat = 10 // アナウンスメッセージのフォントサイズ
    
    // アニメーションに関する定数
    private let animationDuration: Double = 0.3 // アニメーションの時間

    /// アナウンスのデータモデルを定義。Identifiableに準拠させ、リスト内のアイテムを一意に識別できるようにする。
    struct AnnounceMessage: Identifiable, Equatable {
        let id = UUID()
        let message: String
    }
    
    /// アナウンスのリストを状態として保持。リストの変更が自動的にUIに反映される。
    @State private var announceList: [AnnounceMessage] = []
    
    /// コミット結果を受け取るためのBindingプロパティ
    @Binding var isCommitSuccess: Bool?

    var body: some View {
        // ZStackで複数のビューを重ねて配置。他のコンテンツの上にUI要素を重ねる。
        ZStack {
            // 他のビュー（例: MapView）のプレースホルダー
            Color.clear
            
            // アナウンスボタンエリア: 画面中央に配置
            // ボタンを横並びにするHStack
            HStack(spacing: buttonSpacing) { // ボタン間のスペースを定数化
                // アナウンス1を追加するボタン
                Button("アナウンス1") {
                    addAnnounce(message: "これはアナウンス1です。ああああああああああああ")
                }
                .buttonStyle(.borderedProminent) // ボタンのスタイルを適用
                
                // アナウンス2を追加するボタン
                Button("アナウンス2") {
                    addAnnounce(message: "これはアナウンス2です。")
                }
                .buttonStyle(.borderedProminent)
                
                // アナウンス3を追加するボタン
                Button("アナウンス3") {
                    addAnnounce(message: "これはアナウンス3です。")
                }
                .buttonStyle(.borderedProminent)
            }
            
            // アナウンス表示エリア: 画面右上に配置
            // アナウンスを縦に並べるVStack
            VStack(alignment: .trailing, spacing: 2) {
                // announceList配列の各アイテムに対してビューを生成
                ForEach(announceList) { announce in
                    // 個々のアナウンスメッセージのテキストビュー
                    Text(announce.message)
                        .font(.system(size: announceFontSize)) // 文字サイズを定数化
                        .padding(.horizontal, announcePaddingHorizontal) // 左右の余白を定数化
                        .padding(.vertical, announcePaddingVertical) // 上下の余白を定数化
                        .background(Color.white.opacity(0.15)) // 背景を半透明の白に設定
                        .foregroundColor(.white) // テキストの色を白に設定
                        .cornerRadius(cornerRadius) // 角丸を定数化
                        // アナウンスの追加・削除時のアニメーションを定義
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing), // 追加時は右からスライドイン
                            removal: .opacity.combined(with: .move(edge: .top)) // 削除時は透明になりながら上に移動
                        ))
                        // ビューが表示されたときに実行される処理
                        .onAppear {
                            removeAnnounceAfterDelay(Announce: announce, delay: announceRemovalDelay) // 自動削除までの時間を定数化
                        }
                }
            }
            // VStackの内側に余白を追加
            .padding(announceAreaPadding) // 内側の余白を定数化
            // アナウンスエリアのサイズと配置を定義
            .frame(maxWidth: announceAreaMaxWidth, maxHeight: announceAreaMaxHeight, alignment: .bottomTrailing) // サイズを定数化
            // アナウンスエリア全体の背景と角丸を設定
            .background(Color.yellow.opacity(0.5))
            .cornerRadius(cornerRadius) // 角丸を定数化
            // アナウンスエリア全体を画面右上に配置
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top, announceAreaTopPadding) // 上部の余白を定数化
            .padding(.trailing, announceAreaTrailingPadding) // 右部の余白を定数化
        }
        // announceList配列の変更時にアニメーションを適用
        .animation(.easeOut(duration: animationDuration), value: announceList) // アニメーションの時間を定数化
        // isCommitSuccessの値が変更されたときに実行される処理
        .onChange(of: isCommitSuccess) { oldValue, newValue in
            if let result = newValue {
                if result {
                    addAnnounce(message: "コミットが成功しました。")
                } else {
                    addAnnounce(message: "コミットが失敗しました。")
                }
                isCommitSuccess = nil
            }
        }
    }
    
    /// 新しいアナウンスを追加し、アナウンスの件数を管理するメソッド
    private func addAnnounce(message: String) {
        // アニメーションを適用する範囲を指定
        withAnimation {
            // アナウンスの件数が5件以上の場合、一番古いアナウンスを削除
            if announceList.count >= maxAnnounceCount { // 最大アナウンス件数を定数化
                announceList.removeFirst()
            }
            // 新しいアナウンスをリストに追加
            announceList.append(AnnounceMessage(message: message))
        }
    }
    
    /// 指定されたアナウンスを指定時間後に削除するメソッド
    private func removeAnnounceAfterDelay(Announce: AnnounceMessage, delay: TimeInterval) {
        // メインスレッドで遅延実行
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // アニメーションを適用する範囲を指定
            withAnimation {
                // 配列から該当のアナウンスをIDで検索して削除
                announceList.removeAll { $0.id == Announce.id }
            }
        }
    }
}
