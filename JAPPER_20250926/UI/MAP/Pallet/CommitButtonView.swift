// MARK: - CommitButtonView
import SwiftUI
import UIKit // 触覚フィードバックのために必要

struct CommitButtonView: View {
    // アプリケーションロジックに関する定数
    private let successResetDelay: TimeInterval = 2.0 // 成功/失敗状態からのリセット遅延時間
    private let idleResetDelay: TimeInterval = 1.0 // ローディング状態からのリセット遅延時間
    
    // UIレイアウトに関する定数
    private let buttonWidth: CGFloat = 100 // ボタンの幅
    private let buttonHeight: CGFloat = 40 // ボタンの高さ
    private let buttonCornerRadius: CGFloat = 10 // ボタンの角丸
    private let buttonContentSpacing: CGFloat = 50 // ボタンコンテンツ間のスペース
    private let successIconScale: CGFloat = 1.2 // 成功アイコンのスケール
    private let failureIconScale: CGFloat = 1.2 // 失敗アイコンのスケール
    private let defaultIconScale: CGFloat = 0.8 // デフォルトアイコンのスケール
    
    // MARK: - 設定フラグ
    @State private var shouldSimulateSuccess: Bool = true // trueで成功、falseで失敗をシミュレート
    
    // MARK: - 状態を管理するEnum
    enum Status {
        case idle
        case loading
        case success
        case failure
    }
    
    // MARK: - 状態変数とフィードバックジェネレータ
    @State private var buttonStatus: Status = .idle
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light) // 最も弱い触覚フィードバックを生成
    private let notificationFeedback = UINotificationFeedbackGenerator() // 成功/失敗の通知フィードバックを生成
    
    /// コミット結果を親ビューに通知するためのBindingプロパティ
    @Binding var isCommitSuccess: Bool?

    var body: some View {
        VStack(spacing: buttonContentSpacing) { // ボタンコンテンツ間のスペースを定数化
            Button(action: {
                withAnimation(nil) {
                    buttonStatus = .loading
                }
                simulateAndResetState()
            }) {
                buttonContent(for: buttonStatus)
            }
            .disabled(buttonStatus != .idle)
        }
        .padding()
        // MARK: - 状態変化に応じた触覚フィードバック
        .onChange(of: buttonStatus) { oldValue, newValue in
            switch newValue {
            case .loading:
                if oldValue == .idle {
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred() // 弱い衝撃フィードバック
                }
            case .success:
                if oldValue == .loading {
                    notificationFeedback.prepare()
                    notificationFeedback.notificationOccurred(.success) // 成功通知フィードバック
                    isCommitSuccess = true
                }
            case .failure:
                if oldValue == .loading {
                    notificationFeedback.prepare()
                    notificationFeedback.notificationOccurred(.error) // エラー通知フィードバック
                    isCommitSuccess = false
                }
            case .idle:
                break
            }
        }
    }
    
    // MARK: - プライベートヘルパーメソッド
    private func simulateAndResetState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + successResetDelay) { // 成功/失敗状態からのリセット遅延時間を定数化
            if shouldSimulateSuccess {
                withAnimation(.spring()) {
                    buttonStatus = .success // 成功時の状態遷移アニメーション
                }
            } else {
                withAnimation(.spring()) {
                    buttonStatus = .failure // 失敗時の状態遷移アニメーション
                }
            }
            shouldSimulateSuccess.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + idleResetDelay) { // ローディング状態からのリセット遅延時間を定数化
                withAnimation(.easeOut) {
                    buttonStatus = .idle // idle状態に戻る際のアニメーション
                }
            }
        }
    }
    
    // MARK: - ボタンのコンテンツビュー
    private func buttonContent(for status: Status) -> some View {
        ZStack {
            Text("コミット")
                .opacity(status == .idle ? 1 : 0)
            
            ProgressView()
                .opacity(status == .loading ? 1 : 0)
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .scaleEffect(status == .success ? successIconScale : defaultIconScale) // スケールを定数化
                .opacity(status == .success ? 1 : 0)
                .animation(.spring(), value: status) // 成功アイコンのスケールアニメーション
            
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .scaleEffect(status == .failure ? failureIconScale : defaultIconScale) // スケールを定数化
                .opacity(status == .failure ? 1 : 0)
                .animation(.spring(), value: status) // 失敗アイコンのスケールアニメーション
        }
        .frame(width: buttonWidth, height: buttonHeight) // 幅と高さを定数化
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(buttonCornerRadius) // 角丸を定数化
    }
}
