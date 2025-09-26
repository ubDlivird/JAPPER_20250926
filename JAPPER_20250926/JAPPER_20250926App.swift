// JAPPER_20250926App.swift
import SwiftUI
import FirebaseCore
import MapLibre

// MARK: - AppDelegateの定義
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        MLNMapView.appearance().automaticallyAdjustsContentInset = false
        return true
    }
}

// MARK: - メインアプリケーション構造体
@main
struct JAPPER_20250926App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 修正: 画面状態管理をContentViewに一任するため、このプロパティは不要
    // @State private var isMapViewActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            // 修正: アプリのルートビューをContentViewに設定する
            ContentView()
        }
    }
}
