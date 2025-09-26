// MARK: - Favorites View
import SwiftUI

// MARK: - データモデル
/// お気に入りアイテムのデータ構造
struct FavoriteItem: Identifiable {
    let id = UUID()
    let title: String
    let thumbnailUrl: String
}

struct FavoritesView: View {
    
    // MARK: - Properties
    /// サンプルデータ
    /// ビューの状態として管理
    @State private var favoriteItems: [FavoriteItem] = [
        FavoriteItem(title: "東京都庁", thumbnailUrl: "tokyo_metropolitan_government"),
        FavoriteItem(title: "東京タワー", thumbnailUrl: "tokyo_tower"),
        FavoriteItem(title: "浅草寺", thumbnailUrl: "sensoji_temple")
    ]
    
    // MARK: - Body
    var body: some View {
        // 新規: ナビゲーションコンテナを追加
        NavigationStack {
            // お気に入りリストの表示
            List {
                // 各お気に入りアイテムをループ処理
                ForEach(favoriteItems) { item in
                    // 各行のレイアウト
                    HStack {
                        // MARK: サムネイル画像
                        Image(item.thumbnailUrl)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        
                        // MARK: タイトル
                        Text(item.title)
                            .font(.headline)
                            .padding(.leading, 8)
                    }
                }
            }
            .navigationTitle("お気に入り")
            .navigationBarTitleDisplayMode(.inline) // タイトルをインライン表示にしてナビゲーションバーを薄くする
        }
    }
}

//// MARK: - Preview
//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView()
//    }
//}
