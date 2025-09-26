//
//  TitleView.swift
//  OSMViewer
//
//  Created by SHUYA on 2025/09/12.
//

import SwiftUI

/// アプリのタイトルとバージョンを表示するView
struct TitleView: View {
    // MARK: - 定数
    private let titleText = "JAPPER" // タイトルのテキストを定義
    private let versionText = "-ver.β" // バージョンのテキストを定義
    
    private let titleFontSize: CGFloat = 100 // タイトルのフォントサイズを定義
    private let versionFontSize: CGFloat = 20 // バージョンのフォントサイズを定義
    
    private let titleColors: [Color] = [.red, .green, .blue, .yellow, .orange, .pink, .purple] // タイトルの色を定義
    
    // ハードコーディングされていた値を定数化
    private let versionTextYOffset: CGFloat = 15.0 // バージョンテキストのY軸オフセット
    private let versionTextShadowRadius: CGFloat = 2.0 // バージョンテキストの影の半径
    private let versionTextShadowY: CGFloat = 2.0 // バージョンテキストの影のY軸オフセット
    private let versionTextOpacity: Double = 0.8 // バージョンテキストの透明度
    private let hStackSpacing: CGFloat = -10.0 // タイトル文字を並べるHStackのスペース
    private let titleTextShadowRadius: CGFloat = 5.0 // タイトル文字の影の半径
    private let titleTextShadowY: CGFloat = 5.0 // タイトル文字の影のY軸オフセット
    private let titleTextShadowOpacity: Double = 0.5 // タイトル文字の影の透明度
    private let titleDefaultColor: Color = .white // タイトル文字のデフォルト色
    private let versionShadowColorOpacity: Double = 0.8 // バージョン文字の影の透明度
    
    // MARK: - ボディ
    var body: some View { // Viewの本体を定義
        // MARK: - タイトルとバージョン表示
        buildTitleText() // タイトルを生成
            .overlay( // タイトルの上に別のビューを重ねて配置
                Text(versionText) // バージョンのテキストを定義
                    .font(.system(size: versionFontSize, weight: .bold)) // バージョンのフォントスタイルを指定
                    .foregroundColor(.white.opacity(versionTextOpacity)) // バージョンの文字色を半透明の白に設定
                    .shadow(color: .black.opacity(versionShadowColorOpacity), radius: versionTextShadowRadius, x: 0, y: versionTextShadowY) // バージョンの影を設定
                    .offset(x: 0, y: versionTextYOffset), // バージョンを親ビューからx軸0、y軸15ポイントずらす
                alignment: .bottomTrailing // 重ねるビューを親ビューの右下に配置
            )
    }
    
    // MARK: - ヘルパーメソッド
    
    /// タイトルテキストを1文字ずつランダムな色で生成するメソッド
    private func buildTitleText() -> some View { // ビューを返すプライベートメソッドを定義
        HStack(spacing: hStackSpacing) { // ビューを横に並べるHStackを使用
            ForEach(Array(titleText.enumerated()), id: \.offset) { _, char in // タイトルの各文字をループ処理
                Text(String(char)) // 各文字をテキストビューとして表示
                    .font(.custom("ChalkboardSE-Bold", size: titleFontSize)) // 文字のカスタムフォントを指定
                    .foregroundColor(titleColors.randomElement() ?? titleDefaultColor) // 文字の色をランダムに設定
                    .shadow(color: .black.opacity(titleTextShadowOpacity), radius: titleTextShadowRadius, x: 0, y: titleTextShadowY) // 文字の影を設定
            }
        }
    }
}

//// MARK: - プレビュー
//struct TitleView_Previews: PreviewProvider { // プレビューを提供
//    static var previews: some View {
//        TitleView() // TitleViewをプレビュー
//            .previewLayout(.sizeThatFits) // プレビューサイズをコンテンツに合わせる
//            .padding() // パディングを追加
//    }
//}
