import SwiftUI
import UIKit // 触覚フィードバックのために必要

struct CloseButtonView: View {
    let closeAction: () -> Void
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light) // 最も弱い触覚フィードバックを生成
    
    // UIレイアウトに関する定数
    private let buttonWidth: CGFloat = 100 // ボタンの幅
    private let buttonHeight: CGFloat = 40 // ボタンの高さ
    private let buttonCornerRadius: CGFloat = 10 // ボタンの角丸

    var body: some View {
        Button(action: {
            impactFeedback.impactOccurred() // ボタン押下時に弱い衝撃フィードバックを発生
            closeAction()
        }) {
            Text("閉じる")
                .foregroundColor(.white)
                .frame(width: buttonWidth, height: buttonHeight) // 幅と高さを定数化
                .background(Color.gray)
                .cornerRadius(buttonCornerRadius) // 角丸を定数化
        }
    }
}

// MARK: - プレビュー
#Preview {
    CloseButtonView(closeAction: {})
}
