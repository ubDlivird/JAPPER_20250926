import SwiftUI
import GoogleMobileAds // AdMobのフレームワークをインポート

/// アプリのホーム画面を定義するView
struct HomeView: View {
    // MARK: - 定数
    /// タブバーのアイコン
    /// 5つのタブに対応するアイコンを定義
    private let tabItems = [
        "house",
        "magnifyingglass",
        "applepencil.and.scribble",
        "heart.fill",
        "person.fill"
    ]
    
    // MARK: - プロパティ
    /// 選択中のタブのインデックスを保持
    @State private var selectedTab = 0

    /// ホーム画面の描画と配置を行う
    var body: some View {
        // MARK: - メインコンテンツ
        VStack(spacing: 0) {
            // MARK: - AdMobバナー広告
            // アダプティブバナーの高さに合わせて動的に高さを調整するため、GeometryReaderを使用
            GeometryReader { geometry in
                let adSize = portraitAnchoredAdaptiveBanner(width: geometry.size.width)
                AdBannerView()
                    .frame(width: adSize.size.width, height: adSize.size.height)
            }
            .frame(height: 50) // ここにデフォルトの高さを設定
            
            // TabViewの作成
            TabView(selection: $selectedTab) {
                // MARK: - タブの定義
                // 1番目のタブ (Home)
                StartMainView()
                    .tag(0)
                    .tabItem {
                        Label("Home", systemImage: tabItems[0])
                    }
                
                // 2番目のタブ
                Text("タブ \(tabItems[1]) の内容")
                    .tag(1)
                    .tabItem {
                        Label("Search", systemImage: tabItems[1])
                    }
                
                // 3番目のタブ
                MainMapView()
                    .tag(2)
                    .tabItem {
                        Label("Add", systemImage: tabItems[2])
                    }
                
                // 4番目のタブ
                Text("タブ \(tabItems[3]) の内容")
                    .tag(3)
                    .tabItem {
                        Label("Favorites", systemImage: tabItems[3])
                    }
                
                // 5番目のタブ
                ProfileView()
                    .tag(4)
                    .tabItem {
                        Label("Profile", systemImage: tabItems[4])
                    }
            }
            .onAppear {
                UITabBar.appearance().isTranslucent = true
                UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }
        }
    }
}

//// MARK: - プレビュー
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
