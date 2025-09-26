import SwiftUI
import UIKit // 触覚フィードバックのために必要

// MARK: - 色ボタンのデータモデル
/// 色ボタンのリストを管理するための識別可能なデータ構造
struct ColorButtonData: Identifiable {
    let id = UUID()
    let color: Color
}

// MARK: - 個々の色ボタンビュー
/// タップ可能な色ボタンのUIを定義
struct ColorButton: View {
    let color: Color
    @Binding var selectedColor: Color
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light) // 最も弱い触覚フィードバックを生成
    
    // UIレイアウトに関する定数
    private let buttonPadding: CGFloat = 3 // ボタンのパディング
    private let overlayLineWidth: CGFloat = 2 // オーバーレイの線の太さ
    private let shadowRadius: CGFloat = 3 // 影の半径

    var body: some View {
        Button(action: {
            impactFeedback.impactOccurred() // ボタン押下時に弱い衝撃フィードバックを発生
            selectedColor = color
            Logger.shared.logEvent(event: "COLOR_PICKER", status: "色変更", data: color.description)
        }) {
            Circle()
                .fill(color)
                .padding(buttonPadding) // パディングを定数化
                .overlay(
                    Circle()
                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: overlayLineWidth) // 線の太さを定数化
                )
                .shadow(radius: selectedColor == color ? shadowRadius : 0) // 影の半径を定数化
        }
    }
}

// MARK: - 色ボタンのコレクションビュー
/// 複数の色ボタンを配置する親ビュー
struct ColorButtonsView: View {
    // UIレイアウトに関する定数
    private let buttonSpacing: CGFloat = 5 // ボタン間のスペース

    // 呼び出し元から選択中の色をバインディングとして受け取る
    @Binding var selectedColor: Color
    
    // 表示する色ボタンのデータリスト
    let colors: [ColorButtonData] = [
        .init(color: .green),
        .init(color: .blue),
        .init(color: .red),
        .init(color: .yellow),
        .init(color: .orange),
        .init(color: .purple),
        .init(color: .cyan),
        .init(color: .mint)
    ]
    
    // 2つのHStackに色を分割して表示
    var body: some View {
        VStack(spacing: buttonSpacing) { // ボタン間のスペースを定数化
            HStack(spacing: buttonSpacing) { // ボタン間のスペースを定数化
                ForEach(colors.prefix(4)) { colorData in
                    ColorButton(color: colorData.color, selectedColor: $selectedColor)
                }
            }
            HStack(spacing: buttonSpacing) { // ボタン間のスペースを定数化
                ForEach(colors.suffix(4)) { colorData in
                    ColorButton(color: colorData.color, selectedColor: $selectedColor)
                }
            }
        }
    }
}
