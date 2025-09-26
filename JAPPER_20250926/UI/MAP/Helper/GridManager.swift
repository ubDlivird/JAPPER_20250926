// MARK: - GridManager.swift
// このファイルは、地図上のグリッド線や特定の図形を生成・描画するロジックを管理します。

import CoreLocation
import MapLibreSwiftDSL
import MapLibreSwiftUI
import MapLibre
import SwiftUI // SwiftUI.Colorを使用するためにインポート

// MARK: - GridManager
enum GridManager {

    // MARK: - 日本列島グリッドレイヤー
    /// 指定されたマス目数に基づいて日本列島を分割するグリッド線のレイヤーを生成
    static func japanGridLayer(boundingBox: AdjustableBoundingBox) -> LineStyleLayer {
        // 呼び出し元: グリッド生成処理開始ログ
        let startTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "GRID_GEN", status: "START")

        // 呼び出し元: グリッド線の座標を生成
        let gridLines = generateGridLines(boundingBox: boundingBox)

        // 処理: グリッド線用のMLNMultiPolylineFeatureを作成
        let multiPolyline = MLNMultiPolylineFeature(polylines: gridLines)

        // 処理: 線のデータソースを作成
        let gridSource = ShapeSource(identifier: "japan-grid-source") {
            multiPolyline
        }

        // 処理: 線を描画するレイヤーを生成して返す
        let layer = LineStyleLayer(identifier: "japan-grid-layer", source: gridSource)
            // 修正: SwiftUI.ColorをUIColorに変換して設定
            .lineColor(UIColor(GridSettings.gridLineColor))
            .lineWidth(Float(GridSettings.gridLineWidth)) // DoubleからFloatへキャスト

        // 呼び出し元: グリッド生成処理終了ログ
        let duration = Logger.shared.getDuration(from: startTime)
        Logger.shared.logEvent(event: "GRID_GEN", status: "END", duration: duration)

        return layer
    }

    // MARK: - グリッド線座標生成（メルカトル補正版）
    /// 日本列島バウンディングボックス内にメルカトル図法で見たときに等分されるグリッド線の座標配列を生成（東西南北を動的に変更可能）
    private static func generateGridLines(boundingBox: AdjustableBoundingBox) -> [MLNPolylineFeature] {
        // 呼び出し元: グリッド線座標生成開始ログ
        let startTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "GRID_LINE_CALC", status: "START")

        var lines: [MLNPolylineFeature] = []
        let box = boundingBox

        // 処理: 日本バウンディングボックスのメルカトル座標を計算
        let mercatorLatMin = box.minLatitude.toMercatorY()
        let mercatorLatMax = box.maxLatitude.toMercatorY()

        // 処理: 各マス目の緯度・経度方向のサイズを計算
        let latSpacing = (mercatorLatMax - mercatorLatMin) / GridSettings.numberOfVerticalCells
        let lonSpacing = (box.maxLongitude - box.minLongitude) / GridSettings.numberOfHorizontalCells

        // MARK: - 縦方向のグリッド線を生成（経度線）
        for i in 0...Int(GridSettings.numberOfHorizontalCells) {
            let longitude = box.minLongitude + Double(i) * lonSpacing

            let coordinates = [
                CLLocationCoordinate2D(latitude: box.minLatitude, longitude: longitude),
                CLLocationCoordinate2D(latitude: box.maxLatitude, longitude: longitude)
            ]
            let polyline = MLNPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            lines.append(polyline)
        }

        // MARK: - 横方向のグリッド線を生成（緯度線）
        for i in 0...Int(GridSettings.numberOfVerticalCells) {
            // 処理: メルカトルY座標を均等に分割
            let mercatorY = mercatorLatMin + Double(i) * latSpacing
            // 処理: メルカトルY座標から緯度に戻す
            let latitude = mercatorY.toLatitude()

            let coordinates = [
                CLLocationCoordinate2D(latitude: latitude, longitude: box.minLongitude),
                CLLocationCoordinate2D(latitude: latitude, longitude: box.maxLongitude)
            ]
            let polyline = MLNPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
            lines.append(polyline)
        }

        // 呼び出し元: グリッド線座標生成終了ログ
        let duration = Logger.shared.getDuration(from: startTime)
        Logger.shared.logEvent(event: "GRID_LINE_CALC", status: "END", duration: duration)

        return lines
    }
}

// MARK: - ヘルパー関数（変換ロジックを追加）
private extension CLLocationDegrees {
    /// 緯度をラジアンに変換する
    func toRadians() -> Double {
        return self * .pi / 180.0
    }

    /// 緯度をメルカトル座標系のY軸（投影）に変換する
    func toMercatorY() -> Double {
        return log(tan(self.toRadians()) + (1 / cos(self.toRadians())))
    }
}

private extension Double {
    /// メルカトル座標系のY軸から緯度（逆投影）に戻す
    func toLatitude() -> CLLocationDegrees {
        let latRad = 2 * atan(exp(self)) - (.pi / 2)
        return latRad * 180.0 / .pi
    }
}
