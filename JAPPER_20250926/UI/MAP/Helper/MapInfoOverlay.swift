// MapInfoOverlay.swift
// このファイルは、地図情報のオーバーレイビューを管理します。

import SwiftUI
import CoreLocation
import MapLibreSwiftUI // MapViewCamera型を認識するために必要

struct MapInfoOverlayView: View {
    // 表示するカメラ情報
    let camera: MapViewCamera

    var body: some View {
        VStack(alignment: .trailing) {
            // 処理: switch文を使ってcamera.stateから情報を取得
            switch camera.state {
            case .centered(let onCoordinate, let zoom, _, _, _):
                Text("緯度: \(String(format: "%.4f", onCoordinate.latitude))")
                Text("経度: \(String(format: "%.4f", onCoordinate.longitude))")
                Text("ズーム: \(String(format: "%.2f", zoom))")
            default:
                Text("カメラ情報: \(camera.description)")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding()
    }
}
