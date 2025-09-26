// MARK: - PaletteView
import SwiftUI
import MapLibre
import MapLibreSwiftUI
import MapLibreSwiftDSL

// MARK: - PaletteView
struct PaletteView: View {
    // UIレイアウトに関する定数
    private let paletteContentPadding: CGFloat = 10 // パレットコンテンツのパディング
    private let paletteHeight: CGFloat = 180 // パレットの高さ
    private let cornerRadius: CGFloat = 20 // 角丸の半径
    private let buttonZoneHeight: CGFloat = 60 // ボタンエリアの高さ
    private let buttonSpacing: CGFloat = 20 // ボタン間のスペース
    private let buttonImageSize: CGFloat = 50 // ボタンアイコンのサイズ
    private let buttonCircleFrame: CGFloat = 60 // ボタンの円形背景のサイズ
    private let buttonBottomPadding: CGFloat = 20 // ボタンの下部パディング

    // アニメーションに関する定数
    private let animationDuration: Double = 0.3 // アニメーションの時間

    // 呼び出し元: 塗りつぶしモードの状態をバインディングとして受け取る
    @Binding var isPaintingEnabled: Bool

    // 呼び出し元: 現在選択されている色をバインディングとして受け取る
    @Binding var selectedColor: Color

    // 呼び出し元: 塗りつぶされたセルをバインディングとして受け取る
    @Binding var paintedCells: MLNMultiPolygonFeature

    @Namespace private var animationNamespace

    @State private var isPaletteVisible: Bool = false

    // コミット結果を親ビューからBindingとして受け取る
    @Binding var isCommitSuccess: Bool?

    var body: some View {
        ZStack(alignment: .bottom) {
            if isPaletteVisible {
                VStack {
                    VStack {
                        ColorButtonsView(selectedColor: $selectedColor)

                        Spacer()

                        HStack(spacing: buttonSpacing) { // ボタン間のスペースを定数化
                            Spacer()
                            CloseButtonView {
                                self.isPaletteVisible = false
                                self.isPaintingEnabled = false
                                Logger.shared.logEvent(event: "PAINT_MODE", status: "状態変更", data: self.isPaintingEnabled ? "有効" : "無効")
                            }
                            CommitButtonView(isCommitSuccess: $isCommitSuccess)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: buttonZoneHeight) // ボタンエリアの高さを定数化
                        .background(.ultraThinMaterial)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity)) // パレットコンテンツ全体の下からのアニメーション
                }
                .frame(maxWidth: .infinity, maxHeight: paletteHeight) // パレットの高さを定数化
                .background(.ultraThinMaterial)
                .cornerRadius(cornerRadius) // 角丸を定数化
                .padding(.vertical, paletteContentPadding) // パレットコンテンツの上下パディングを定数化
                .padding(.horizontal, paletteContentPadding) // パレットコンテンツの左右パディングを定数化
            } else {
                Button(action: {
                    self.isPaletteVisible = true
                    if isPaintingEnabled == false {
                        self.isPaintingEnabled = true
                    }
                    Logger.shared.logEvent(event: "PAINT_MODE", status: "状態変更", data: self.isPaintingEnabled ? "有効" : "無効")
                }) {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .font(.system(size: buttonImageSize)) // ボタンアイコンのサイズを定数化
                        .foregroundColor(isPaintingEnabled ? .green : .blue)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: buttonCircleFrame, height: buttonCircleFrame) // ボタンの円形背景のサイズを定数化
                        )
                        .symbolEffect(.bounce.down.wholeSymbol, options: .nonRepeating, value: isPaintingEnabled) // ボタンが有効になった際のバウンスアニメーション
                }
                .padding(.bottom, buttonBottomPadding) // ボタンの下部パディングを定数化
                .transition(.move(edge: .bottom).combined(with: .opacity)) // ボタンの表示・非表示アニメーション
            }
            // AnnounceViewを追加
            AnnounceView(isCommitSuccess: $isCommitSuccess)
        }
        .matchedGeometryEffect(id: "paintButton", in: animationNamespace) // ボタンがパレットに切り替わるアニメーション
        .animation(.spring(), value: isPaletteVisible) // isPaletteVisibleの変化に対するスプリングアニメーション
    }
}
