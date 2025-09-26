// MARK: - MainMapView.swift
// このファイルは、アプリのメインビューであり、各機能を統合します。

import SwiftUI
import MapLibreSwiftUI
import MapLibreSwiftDSL
import CoreLocation
import MapLibre

// MARK: - MainMapView
struct MainMapView: View {
    // 呼び出し元: カメラの初期位置とズームレベルを管理
    @State private var camera: MapViewCamera = MapSettings.initialCamera
    
    // 処理: バウンディングボックスの値を管理するオブジェクト
    @StateObject private var adjustableBoundingBox = AdjustableBoundingBox()
    
    // 処理: 塗りつぶしモードの有効/無効を管理
    @State private var isPaintingEnabled: Bool = false
    
    // 修正: 現在選択されている色を管理
    @State private var selectedColor: Color = .green
    
    // 修正: FirestoreManagerをObservableObjectとして参照
    @StateObject private var firestoreManager = FirestoreManager.shared

    // コミット結果を管理する状態変数
    @State private var isCommitSuccess: Bool? = nil
    
    var body: some View {
        ZStack {
            MapView(styleURL: MapSettings.mapStyleURL, camera: $camera) {
                // 修正: ペイントモードが有効な場合のみグリッドレイヤーを表示
                if isPaintingEnabled {
                    // 呼び出し元: 調整された値を渡してグリッドレイヤーを追加
                    GridManager.japanGridLayer(boundingBox: adjustableBoundingBox)
                }
                
                // 呼び出し元: 塗りつぶされたセルを描画するレイヤーを追加
                // 修正: firestoreManagerからpaintedCellsを参照
                FillStyleLayer(identifier: "painted-cells-layer", source: ShapeSource(identifier: "painted-cells-source") {
                    firestoreManager.paintedCells
                })
                // 修正: SwiftUI.ColorをUIColorに変換して設定
                .fillColor(UIColor(GridSettings.paintedCellColor))
            }
            // 修正: 塗りつぶしモードの状態をバインディングとして渡す
            // 修正: paintedCellsをfirestoreManagerから参照
            .onTapMapGesture(
                isPaintingEnabled: $isPaintingEnabled,
                paintedCells: $firestoreManager.paintedCells,
                camera: camera,
                selectedColor: selectedColor,
                firestoreManager: firestoreManager
            )
            // 修正: 地図が画面に表示された時に、タイマー付きのログ出力タスクを開始
            .onAppear {
                Logger.shared.logEvent(event: "MAP_LIFECYCLE", status: "ON_APPEAR")
                
                // 処理: 0.5秒ごとに合計10回ログを出力（5秒間）
                for i in 1...10 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                        Logger.shared.logEvent(event: "MAP_STATUS", status: "LOAD_CHECK", data: "チェック回数: \(i)")
                    }
                }
            }
            
            // MARK: - MapInfoOverlayView (画面左上)
            // 処理: 現在のカメラ情報($camera)を渡すことで、ズームレベルを含む情報を常時表示
            MapInfoOverlayView(camera: camera)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // 左上に配置
            .padding()
            
            // MARK: - デバッグ用ビュー
            // 処理: デバッグ設定に基づいてUIの表示を切り替える
            if DebugSettings.gridSetUi {
                VStack {
                    Spacer()
                    BoundingBoxAdjusterView(boundingBox: adjustableBoundingBox)
                }
            }
            
            // MARK: - パレットビュー(画面下)
            VStack {
                Spacer()
                PaletteView(
                    isPaintingEnabled: $isPaintingEnabled,
                    selectedColor: $selectedColor,
                    // 修正: paintedCellsをBindingとして渡す
                    paintedCells: $firestoreManager.paintedCells,
                    isCommitSuccess: $isCommitSuccess
                )
            }
        }
        .onAppear {
            Logger.shared.logEvent(event: "VIEW_LIFECYCLE", status: "START")
            // 呼び出し元: データベースから既存の塗りつぶしセルを読み込む
            // 修正: firestoreManagerのメソッドを呼び出す
            firestoreManager.fetchPaintedCells()
        }
    }
}
