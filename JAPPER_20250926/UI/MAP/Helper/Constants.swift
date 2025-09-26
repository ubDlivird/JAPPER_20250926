// Constants.swift
// このファイルは、アプリ全体で共有される定数を保持します。

import SwiftUI
import CoreLocation
import MapLibreSwiftUI
import MapLibre

// MARK: - MapSettings
enum MapSettings {
    /// 地図のスタイルを読み込むURL
    static let mapStyleURL: URL = URL(string: "https://api.maptiler.com/maps/jp-mierune-streets/style.json?key=GF6vWNfn0VHkrUVcycbh")!
    
    /// 地図の初期位置とズームレベル
    static let initialCamera: MapViewCamera = .center(
        .init(latitude: 35.681236, longitude: 139.767125), // 東京駅の緯度・経度
        zoom: 3 // 初期ズームレベル
    )
    
    // 緯度補正係数の基準となる中心座標
    static let initialCenterCoordinate: CLLocationCoordinate2D = .init(latitude: 35.681236, longitude: 139.767125)
    
    // 日本列島バウンディングボックスの定義
    static let japanBoundingBox = (
        minLatitude: 17.10,
        maxLatitude: 45.85,
        minLongitude: 122.93,
        maxLongitude: 157.14
    )
}

// MARK: - GridSettings
enum GridSettings {
    // 基準ズームレベルを追加
    static let baseZoomForSpan: Double = 10.0
    
    // 処理: 基準となるマス目のサイズをメートル単位で定義
    static let baseCellSizeInMeters: Double = 100000 // 100km
    
    // 処理: 縦横のセル数を定義
    static let numberOfVerticalCells: Double = 100.0
    static let numberOfHorizontalCells: Double = 100.0
    
    // グリッド線の色と幅
    static let gridLineColor: Color = .blue
    static let gridLineWidth: Double = 1.0
    
    // 塗りつぶされたセルの色
    static let paintedCellColor: Color = .green.opacity(0.5)
}

// MARK: - デバッグ用プロパティ
enum DebugSettings {
    // グリッド調整UIの表示/非表示
    static let showGridAdjuster: Bool = true
    
    // 赤枠の表示/非表示
    static let showRedBox: Bool = true
    
    // ログ出力の有効/無効
    static let enableLogging: Bool = true
    
    // デバッグ用枠線調整UI!の表示/非表示
    static let gridSetUi: Bool = false
}
