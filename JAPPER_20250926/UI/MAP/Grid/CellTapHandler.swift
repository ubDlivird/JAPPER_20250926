// MARK: - CellTapHandler.swift
// このファイルは、地図のタップジェスチャーを処理するロジックを管理します。

import SwiftUI
import MapLibre
import MapLibreSwiftUI
import MapLibreSwiftDSL
import CoreLocation

// MARK: - MapViewの拡張
extension MapView {
    
    // MARK: - タップジェスチャーハンドラ
    /// タップされた位置と現在のカメラ情報に基づいてグリッドセルを塗りつぶし/解除するカスタムモディファイア
    // 修正: selectedColorとfirestoreManagerを引数として追加
    func onTapMapGesture(isPaintingEnabled: Binding<Bool>, paintedCells: Binding<MLNMultiPolygonFeature>, camera: MapViewCamera, selectedColor: Color, firestoreManager: FirestoreManager) -> some View {
        self.onTapMapGesture { context in
            // 修正: 塗りつぶしモードが有効な場合のみ、ハンドル処理を呼び出す
            guard isPaintingEnabled.wrappedValue else {
                return
            }
            
            // 呼び出し元: グリッドセルの処理を呼び出す
            // 修正: selectedColorとfirestoreManagerを渡す
            self.handleTap(at: context.coordinate, paintedCells: paintedCells, selectedColor: selectedColor, firestoreManager: firestoreManager)
        }
    }
    
    // MARK: - グリッドセル処理ロジック
    /// タップされた座標に基づいてグリッドセルを計算し、`paintedCells`を更新します
    // 修正: selectedColorとfirestoreManagerを引数として追加
    private func handleTap(at coordinate: CLLocationCoordinate2D, paintedCells: Binding<MLNMultiPolygonFeature>, selectedColor: Color, firestoreManager: FirestoreManager) {
        // 呼び出し元: 処理開始ログ
        let startTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "START", data: "座標: \(coordinate.latitude), \(coordinate.longitude)")
        
        // 処理: タップ位置が日本バウンディングボックス内にない場合は処理を中止
        guard isCoordinateWithinJapanBoundingBox(coordinate) else {
            // 処理: 処理中止ログ
            Logger.shared.logEvent(event: "TAP_HANDLER", status: "END", duration: Logger.shared.getDuration(from: startTime), data: "日本バウンディングボックス外のため処理中止")
            return
        }
        
        // --- ログ追加箇所 ---
        // 処理: グリッド計算処理の開始ログ
        let gridCalcStartTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "GRID_CALC_START", data: "グリッド計算開始")
        
        // 処理: 日本バウンディングボックスのメルカトル座標を計算
        let mercatorLatMin = MapSettings.japanBoundingBox.minLatitude.toMercatorY()
        let mercatorLatMax = MapSettings.japanBoundingBox.maxLatitude.toMercatorY()
        
        // 処理: 各マス目の緯度・経度方向のサイズを計算（メルカトル補正を考慮）
        let latSpacingMercator = (mercatorLatMax - mercatorLatMin) / GridSettings.numberOfVerticalCells
        let lonSpacing = (MapSettings.japanBoundingBox.maxLongitude - MapSettings.japanBoundingBox.minLongitude) / GridSettings.numberOfHorizontalCells
        
        // 処理: タップ位置のメルカトル座標を計算
        let tappedMercatorY = coordinate.latitude.toMercatorY()
        
        // 処理: タップ位置がどのマス目（セル）に属するかを計算
        let latIndex = floor((tappedMercatorY - mercatorLatMin) / latSpacingMercator)
        let lonIndex = floor((coordinate.longitude - MapSettings.japanBoundingBox.minLongitude) / lonSpacing)
        
        // 処理: セルの原点（左下隅）をメルカトル座標から計算し、通常の緯度に戻す
        let originMercatorY = mercatorLatMin + latIndex * latSpacingMercator
        let originLat = originMercatorY.toLatitude()
        let originLon = MapSettings.japanBoundingBox.minLongitude + lonIndex * lonSpacing
        
        let gridOrigin = CLLocationCoordinate2D(latitude: originLat, longitude: originLon)
        
        // 処理: セルIDを生成
        let cellID = "\(String(format: "%.6f", gridOrigin.latitude))-\(String(format: "%.6f", gridOrigin.longitude))"
        
        // 処理: グリッド計算処理の終了ログ
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "GRID_CALC_END", duration: Logger.shared.getDuration(from: gridCalcStartTime), data: "計算されたセルID: \(cellID)")

        // --- ログ追加箇所 ---
        // 処理: ポリゴン生成・更新処理の開始ログ
        let polygonUpdateStartTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "POLYGON_UPDATE_START", data: "ポリゴン生成・更新開始")

        // 処理: グリッドセルの四隅の座標を生成
        let polygonCoordinates = createGridCellCoordinates(origin: gridOrigin, latSpacing: latSpacingMercator, lonSpacing: lonSpacing)
        
        // 処理: 塗りつぶされたセルのポリゴンを更新
        var currentPaintedPolygons = paintedCells.wrappedValue.polygons
        
        // 処理: 更新前のポリゴン数をログ
        let initialCount = currentPaintedPolygons.count
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "POLYGON_COUNT_BEFORE", data: "現在数: \(initialCount)")
        
        if let index = currentPaintedPolygons.firstIndex(where: {
            guard let id = ($0 as? MLNPolygonFeature)?.attributes["id"] as? String else { return false }
            return id == cellID
        }) {
            // 処理: 既存のセルがあれば削除
            currentPaintedPolygons.remove(at: index)
            Logger.shared.logEvent(event: "TAP_HANDLER", status: "ACTION", data: "削除: \(cellID)")
        } else {
            // 処理: 新しいセルを生成して追加
            let newPolygon = MLNPolygonFeature(coordinates: polygonCoordinates, count: UInt(polygonCoordinates.count))
            newPolygon.attributes = ["id": cellID]
            currentPaintedPolygons.append(newPolygon)
            Logger.shared.logEvent(event: "TAP_HANDLER", status: "ACTION", data: "塗りつぶし: \(cellID)")
        }
        
        paintedCells.wrappedValue = MLNMultiPolygonFeature(polygons: currentPaintedPolygons)
        
        // 処理: 更新後のポリゴン数をログ
        let finalCount = currentPaintedPolygons.count
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "POLYGON_COUNT_AFTER", data: "更新後: \(finalCount)")
        
        // 処理: ポリゴン生成・更新処理の終了ログ
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "POLYGON_UPDATE_END", duration: Logger.shared.getDuration(from: polygonUpdateStartTime))
        
        // 修正: FirestoreManagerを呼び出してデータを保存
        firestoreManager.savePaintedCells(paintedCells: paintedCells.wrappedValue, selectedColor: selectedColor)
        
        // 呼び出し元: 処理終了ログ
        let duration = Logger.shared.getDuration(from: startTime)
        Logger.shared.logEvent(event: "TAP_HANDLER", status: "END", duration: duration)
    }
    
    // MARK: - グリッドセル座標生成（メルカトル補正版）
    /// 左下隅の座標を基にMLNPolygonFeatureの座標配列を生成する
    private func createGridCellCoordinates(origin: CLLocationCoordinate2D, latSpacing: Double, lonSpacing: CLLocationDegrees) -> [CLLocationCoordinate2D] {
        // ログ追加: メソッドの開始ログ
        let methodStartTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "GRID_CELL_GEN", status: "START", data: "座標生成開始")
        
        let originMercatorY = origin.latitude.toMercatorY()
        let mercatorYTop = originMercatorY + latSpacing
        let latitudeTop = mercatorYTop.toLatitude()
        
        let coordinates = [
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude), // bottomLeft
            CLLocationCoordinate2D(latitude: latitudeTop, longitude: origin.longitude), // topLeft
            CLLocationCoordinate2D(latitude: latitudeTop, longitude: origin.longitude + lonSpacing), // topRight
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude + lonSpacing), // bottomRight
            CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude) // 始点に戻って閉じる（bottomLeft）
        ]
        
        // ログ追加: メソッドの終了ログ
        Logger.shared.logEvent(event: "GRID_CELL_GEN", status: "END", duration: Logger.shared.getDuration(from: methodStartTime))
        return coordinates
    }
    
    // MARK: - 日本列島バウンディングボックス内チェック
    /// 指定された座標が日本列島のバウンディングボックス内にあるか確認する
    private func isCoordinateWithinJapanBoundingBox(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return coordinate.latitude >= MapSettings.japanBoundingBox.minLatitude &&
               coordinate.latitude <= MapSettings.japanBoundingBox.maxLatitude &&
               coordinate.longitude >= MapSettings.japanBoundingBox.minLongitude &&
               coordinate.longitude <= MapSettings.japanBoundingBox.maxLongitude
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
        let latRad = 2 * atan(exp(self)) - (.pi / 2)
        return latRad * 180.0 / .pi
    }
}
