// MARK: - FirestoreManager.swift
// Firestoreへのデータアクセスを管理するシングルトンクラス

import Foundation
import FirebaseFirestore
import MapLibre
import MapLibreSwiftUI
import SwiftUI
import CoreLocation

// MARK: - FirestoreManager
/// Firestoreへのデータアクセスを管理するシングルトンクラス
// 修正: ObservableObjectに準拠
class FirestoreManager: ObservableObject {

    // MARK: - プロパティ
    static let shared = FirestoreManager() // シングルトン
    private init() {}

    // 修正: paintedCellsを@Publishedで修飾
    @Published var paintedCells = MLNMultiPolygonFeature(polygons: [])

    // MARK: - コミット：セル情報をFirestoreに保存する

    /// セル情報をFirestoreに保存する
    /// - Parameters:
    ///   - paintedCells: 塗りつぶされたセルの情報
    ///   - selectedColor: 選択中の色
    func savePaintedCells(paintedCells: MLNMultiPolygonFeature, selectedColor: Color) {
        // 呼び出し元: Firestoreへの書き込み処理を開始
        let startTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "FIRESTORE_SAVE", status: "START")
        
        let db = Firestore.firestore()
        let paintedPolygons = paintedCells.polygons

        guard !paintedPolygons.isEmpty else {
            // 処理: 塗りつぶされたセルがない場合はログを出力して終了
            Logger.shared.logEvent(event: "FIRESTORE_SAVE", status: "END", duration: Logger.shared.getDuration(from: startTime), data: "保存するセル情報がありません。")
            return
        }

        // 処理: 塗りつぶされた各セルをループ処理
        for polygon in paintedPolygons {
            // 修正: pointCountが4つであることを確認してから座標にアクセス
            guard polygon.pointCount == 4 else { continue }

            // 処理: ポリゴンの4つの頂点座標を取得
            let coordinates = polygon.coordinates

            // 処理: セルIDを生成 (緯度-経度の形式)
            let cellId = "\(coordinates[0].latitude)-\(coordinates[0].longitude)"

            // 処理: 現在選択中の色を取得し、文字列に変換
            let colorString = selectedColor.description.capitalized

            // 処理: ドキュメントに保存するデータを作成
            let data: [String: Any] = [
                "coordinates": [
                    ["latitude": coordinates[0].latitude, "longitude": coordinates[0].longitude],
                    ["latitude": coordinates[1].latitude, "longitude": coordinates[1].longitude],
                    ["latitude": coordinates[2].latitude, "longitude": coordinates[2].longitude],
                    ["latitude": coordinates[3].latitude, "longitude": coordinates[3].longitude]
                ],
                "color": colorString,
                "timestamp": FieldValue.serverTimestamp() // 処理: サーバータイムスタンプを追加
            ]
            
            // 処理: ドキュメントをFirestoreに保存
            db.collection("paintedCells").document(cellId).setData(data) { err in
                if let err = err {
                    // 処理: 保存失敗ログ
                    Logger.shared.logEvent(event: "FIRESTORE_SAVE", status: "ERROR", data: err.localizedDescription)
                } else {
                    // 処理: 保存成功ログ
                    Logger.shared.logEvent(event: "FIRESTORE_SAVE", status: "END", duration: Logger.shared.getDuration(from: startTime), data: cellId)
                }
            }
        }
    }
    
    // MARK: - フェッチ：セル情報をFirestoreから取得する

    /// Firestoreから塗りつぶされたセル情報を取得する
    // 修正: completionハンドラを削除し、paintedCellsプロパティを更新
    func fetchPaintedCells() {
        // 処理: Firestoreからのデータ取得を開始
        let startTime = Logger.shared.startTimer()
        Logger.shared.logEvent(event: "FIRESTORE_FETCH", status: "START")

        // 呼び出し元: Firestoreインスタンスの取得
        let db = Firestore.firestore()
        
        // 修正: [weak self]でキャプチャ
        db.collection("paintedCells").getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return } // 修正: selfの存在を確認
            
            // 処理: エラーハンドリング
            if let error = err {
                Logger.shared.logEvent(event: "FIRESTORE_FETCH", status: "ERROR", data: error.localizedDescription)
                return // 修正: エラー時は終了
            }

            // 処理: ドキュメントが存在しない場合はnilを返す
            guard let documents = querySnapshot?.documents else {
                Logger.shared.logEvent(event: "FIRESTORE_FETCH", status: "END", duration: Logger.shared.getDuration(from: startTime), data: "0件のセル情報を取得しました。")
                return // 修正: 取得できない場合は終了
            }
            
            Logger.shared.logEvent(event: "FIRESTORE_FETCH", status: "END", duration: Logger.shared.getDuration(from: startTime), data: "\(documents.count)件のセル情報を取得しました。")

            // 処理: 取得したドキュメントからポリゴンを生成
            var polygons: [MLNPolygonFeature] = []
            for document in documents {
                let data = document.data()
                guard let coordArray = data["coordinates"] as? [[String: Double]],
                      coordArray.count == 4 else {
                    continue
                }

                // 処理: 4つの座標を直接取得してポリゴンを生成
                let coordinates = coordArray.compactMap { dict -> CLLocationCoordinate2D? in
                    guard let lat = dict["latitude"], let lon = dict["longitude"] else { return nil }
                    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                }

                guard coordinates.count == 4 else { continue }

                // 処理: 取得した座標でMLNPolygonFeatureを作成
                let polygon = MLNPolygonFeature(coordinates: coordinates, count: UInt(coordinates.count))
                polygons.append(polygon)
            }

            // 処理: 生成したポリゴンからMLNMultiPolygonFeatureを作成
            let multiPolygon = MLNMultiPolygonFeature(polygons: polygons)

            // 修正: プロパティに取得したデータを代入
            self.paintedCells = multiPolygon
        }
    }
}
