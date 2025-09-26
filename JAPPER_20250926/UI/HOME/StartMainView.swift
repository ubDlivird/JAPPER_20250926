//
//  StartView.swift
//  MapLibreTest
//
//
//

import SwiftUI // SwiftUIフレームワークをインポート
import MapLibre // MapLibreフレームワークをインポート

/// アプリのスタート画面を定義するView
struct StartMainView: View {
    // 修正: MapViewへの切り替えを制御するバインディングを削除
    // @Binding var currentScreen: ContentView.Screen

    // MARK: - 定数
    // ハードコーディングされていた値を定数化
    private let vStackSpacing: CGFloat = 20.0 // VStackのスペース
    private let startButtonBottomPadding: CGFloat = 50.0 // スタートボタンの下部パディング
    
    /// スタート画面の描画と配置を行う
    var body: some View { // Viewの本体を定義
        ZStack { // ビューを重ねて配置するZStackを使用
            // MARK: - 1. 背景
            BackPicView() // 背景画像を配置
                .ignoresSafeArea() // セーフエリアを無視して画面全体に表示

            // MARK: - 2. メインコンテンツ (上から順に配置)
            VStack(spacing: vStackSpacing) { // ビューを縦に並べるVStackを使用
                Spacer() // タイトルを画面の中央に配置するための上部スペーサー
                
                // MARK: - 2.1 タイトルとバージョン
                TitleView() // タイトルとバージョンを表示するTitleViewを配置
                
                Spacer() // ボタンを画面の下部に配置するための中央スペーサー
                
            }
        }
    }
}

///// プレビュー用の構造体
//struct StartView_Previews: PreviewProvider { // プレビューを提供
//    static var previews: some View {
//        StartMainView() // StartMainViewをプレビュー
//    }
//}
