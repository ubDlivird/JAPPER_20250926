// MARK: - ContentView.swift
// このファイルは、アプリのメインビューであり、各機能を統合します。

import SwiftUI
import MapLibreSwiftUI
import MapLibreSwiftDSL
import CoreLocation
import MapLibre

// MARK: - ContentView
struct ContentView: View {
    
    var body: some View {
        // 処理: アプリのルートビューをHomeViewに設定する
        HomeView()
    }
}

// MARK: - プレビュー
#Preview {
    ContentView()
}
