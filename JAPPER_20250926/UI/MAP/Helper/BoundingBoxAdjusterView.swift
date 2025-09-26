// BoundingBoxAdjusterView.swift
// このファイルは、地図のバウンディングボックスを調整するためのデバッグUIを提供します。

import SwiftUI
import CoreLocation
import MapLibreSwiftUI
import Firebase // 将来の改修のために残す
import FirebaseFirestore // 将来の改修のために残す

// MARK: - 一時的なバウンディングボックスのデータを保持するクラス
/// グリッド線の描画に使用するバウンディングボックスの値を保持・管理
class AdjustableBoundingBox: ObservableObject {
    @Published var minLatitude: Double = MapSettings.japanBoundingBox.minLatitude
    @Published var maxLatitude: Double = MapSettings.japanBoundingBox.maxLatitude
    @Published var minLongitude: Double = MapSettings.japanBoundingBox.minLongitude
    @Published var maxLongitude: Double = MapSettings.japanBoundingBox.maxLongitude
    
}

// MARK: - BoundingBox調整用ビュー
/// 緯度・経度の値を調整するためのStepperUI
struct BoundingBoxAdjusterView: View {
    // 呼び出し元: BoundingBoxの値をバインド
    @ObservedObject var boundingBox: AdjustableBoundingBox
    
    // 処理: 現在編集中の値を管理する
    @State private var selectedBound: BoundType = .maxLatitude
    
    // 処理: ステッパーの増減量を管理する
    @State private var stepAmount: Double = 0.01

    // 処理: 編集中の値のゲッター
    private var currentValue: Double {
        switch selectedBound {
        case .minLatitude:
            return boundingBox.minLatitude
        case .maxLatitude:
            return boundingBox.maxLatitude
        case .minLongitude:
            return boundingBox.minLongitude
        case .maxLongitude:
            return boundingBox.maxLongitude
        }
    }
    
    // 処理: 編集中の値へのバインディング
    private var bindingForSelectedBound: Binding<Double> {
        switch selectedBound {
        case .minLatitude:
            return $boundingBox.minLatitude
        case .maxLatitude:
            return $boundingBox.maxLatitude
        case .minLongitude:
            return $boundingBox.minLongitude
        case .maxLongitude:
            return $boundingBox.maxLongitude
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            // MARK: - プルダウンで東西南北を選択
            Picker("編集する値", selection: $selectedBound) {
                ForEach(BoundType.allCases) { bound in
                    Text(bound.rawValue).tag(bound)
                }
            }
            .pickerStyle(.segmented)
            
            // MARK: - 調整値の表示
            Text("現在の値: \(currentValue, specifier: "%.2f")")
                .font(.body.bold())
                .frame(maxWidth: .infinity, alignment: .center)

            // MARK: - 増減ボタン
            HStack {
                Text("増減量")
                    .frame(width: 60)
                
                Picker("増減量", selection: $stepAmount) {
                    Text("1").tag(1.0)
                    Text("0.1").tag(0.1)
                    Text("0.01").tag(0.01)
                }
                .pickerStyle(.segmented)
                
                Stepper("", value: bindingForSelectedBound, step: stepAmount)
                    .labelsHidden()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .offset(y: 40) // 処理: UI全体を下に40ポイント移動
    }
}

// MARK: - ヘルパーEnum
/// 編集可能なバウンディングボックスのタイプ
enum BoundType: String, CaseIterable, Identifiable {
    case minLatitude = "南 (minLat)"
    case maxLatitude = "北 (maxLat)"
    case minLongitude = "西 (minLon)"
    case maxLongitude = "東 (maxLon)"
    
    var id: String { self.rawValue }
}
