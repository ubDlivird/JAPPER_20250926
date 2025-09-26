// 新規ファイル: AdBannerView.swift

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerVC = AdBannerViewController()
        return bannerVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 更新ロジックがあればここに追加
    }
}

// 広告のロジックを管理するUIViewController
final class AdBannerViewController: UIViewController {
    // 'GADBannerView' has been renamed to 'BannerView'
    private var bannerView: BannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerView()
    }
    
    // レイアウトの設定
    private func setupBannerView() {
        // MARK: - アダプティブバナーのサイズを取得
        // 'GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth' has been renamed to 'portraitAnchoredAdaptiveBanner(width:)'
        // `portraitAnchoredAdaptiveBanner`はグローバル関数であり、GADAdSizeのメンバーではありません。
        let adSize = portraitAnchoredAdaptiveBanner(width: view.frame.size.width)
        
        // 'GADBannerView' has been renamed to 'BannerView'
        bannerView = BannerView(adSize: adSize)

        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // MARK: - AdMob設定
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // テスト用の広告ユニットID
        bannerView.rootViewController = self
        
        // 'GADRequest' has been renamed to 'Request'
        bannerView.load(Request())
    }
}
