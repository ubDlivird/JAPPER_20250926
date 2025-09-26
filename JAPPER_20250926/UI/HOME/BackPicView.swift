// MARK: - BackPicView.swift
// 背景画像を左右にゆっくりとスクロールさせるビュー。

import SwiftUI

/// 背景画像を左右にゆっくりとスクロールさせるビュー。
/// Timerとsin関数を使用して滑らかな振り子のようなアニメーションを実現する。
struct BackPicView: View {
    
    // スクロール速度を管理する定数。値を小さくすると遅くなる。
    private let scrollSpeed: Double = 0.003
    
    // アニメーションの位相を管理する@Stateプロパティ
    @State private var phase: Double = 0.0
    
    // Timerを管理するプロパティ。
    private let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // 背景の画像レイヤー
            Image(BackPic.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height)
                .offset(x: getOffset())
                .ignoresSafeArea()
                .onReceive(timer) { _ in
                    // タイマーが発火するたびに位相を更新
                    updatePhase()
                }
        }
    }
    
    /// オフセットを計算して返すメソッド
    private func getOffset() -> CGFloat {
        // 画像の元サイズを取得
        guard let image = UIImage(named: BackPic.backgroundImage) else { return 0 }
        let imageAspectRatio = image.size.width / image.size.height

        // 画像の幅を計算
        let imageWidth = UIScreen.main.bounds.height * imageAspectRatio
        
        // 左右の最大オフセットを計算
        let maxOffset = (imageWidth - UIScreen.main.bounds.width) / 2
        
        // sin関数を使用して滑らかなアニメーションを生成
        return maxOffset * CGFloat(sin(phase))
    }
    
    /// 位相を更新するメソッド
    private func updatePhase() {
        phase += scrollSpeed
    }
}

// プレビュー
struct BackPicView_Previews: PreviewProvider {
    static var previews: some View {
        BackPicView()
    }
}
