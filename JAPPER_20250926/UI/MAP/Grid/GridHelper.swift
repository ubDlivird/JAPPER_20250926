// GridHelper.swift
// データベースから取得した座標からグリッドセルポリゴンを生成するヘルパー関数を提供します。

import Foundation
import CoreLocation
import MapLibre
import MapLibreSwiftUI
import MapLibreSwiftDSL

// MARK: - GridHelper
enum GridHelper {
    
    // 修正: この関数は不要になったため削除
    // private static func calculateGridSize() -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    //     ...
    // }
    
    // MARK: - グリッドセルポリゴンの生成
    /// 指定された座標（原点）からグリッドセルを生成する
    /// - Parameter origin: グリッドセルの原点（左下）座標
    /// - Returns: 生成されたグリッドセルを表すMLNPolygonFeature
    static func generateGridCellPolygon(origin: CLLocationCoordinate2D) -> MLNPolygonFeature {
        // 呼び出し元: グリッドセル座標を計算
        let coordinates = createGridCellCoordinates(origin: origin)
        
        // 処理: MLNPolygonFeatureを作成
        let polygon = MLNPolygonFeature(coordinates: coordinates, count: UInt(coordinates.count))
        
        // 処理: ポリゴンにIDを設定
        let cellID = "\(String(format: "%.6f", origin.latitude))-\(String(format: "%.6f", origin.longitude))"
        polygon.attributes = ["id": cellID]
        
        return polygon
    }
    
    // MARK: - グリッドセルの座標を計算
    /// グリッドセルの4つの頂点座標を計算するヘルパー関数
    /// - Parameter origin: グリッドセルの左下座標
    /// - Returns: 4つの頂点座標の配列
    private static func createGridCellCoordinates(origin: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        // 処理: グリッドのメルカトル座標での間隔を計算
        let mercatorLatMin = MapSettings.japanBoundingBox.minLatitude.toMercatorY()
        let mercatorLatMax = MapSettings.japanBoundingBox.maxLatitude.toMercatorY()
        let latSpacingMercator = (mercatorLatMax - mercatorLatMin) / Double(GridSettings.numberOfVerticalCells)
        let lonSpacing = (MapSettings.japanBoundingBox.maxLongitude - MapSettings.japanBoundingBox.minLongitude) / Double(GridSettings.numberOfHorizontalCells)
        
        // 処理: メルカトル座標系で上端の緯度を計算し、緯度に戻す
        let mercatorYTop = origin.latitude.toMercatorY() + latSpacingMercator
        let latitudeTop = mercatorYTop.toLatitude()
        
        // 処理: 4つの座標を生成
        let coordinates = [
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude), // bottomLeft
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude + lonSpacing), // bottomRight
            CLLocationCoordinate2D(latitude: latitudeTop, longitude: origin.longitude + lonSpacing), // topRight
            CLLocationCoordinate2D(latitude: latitudeTop, longitude: origin.longitude), // topLeft
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude) // 始点に戻って閉じる（bottomLeft）
        ]
        
        return coordinates
    }
}

// MARK: - ヘルパー関数（変換ロジックを追加）
private extension CLLocationDegrees {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    /// 緯度をメルカトル座標系のY軸（投影）に変換する
    func toMercatorY() -> Double {
        let latRad = self.toRadians()
        return log(tan(latRad) + (1 / cos(latRad)))
    }
}

private extension Double {
    /// メルカトル座標系のY軸から緯度（逆投影）に戻す
    func toLatitude() -> CLLocationDegrees {
        let latRad = atan(sinh(self))
        return latRad * 180.0 / .pi
    }
}
