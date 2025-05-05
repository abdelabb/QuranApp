import GoogleMobileAds
import SwiftUI

class AdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private var interstitial: InterstitialAd?
     var pageCounter = 0
    private var isAdShowing = false

    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // test ID
    private var shouldShowAtStartup = true

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }

            if let error = error {
                print("❌ Erreur pub : \(error.localizedDescription)")
                return
            }

            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            print("✅ Pub chargée")

            // ➤ Affiche la pub à l’ouverture si on est au démarrage
            if self.shouldShowAtStartup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first?.rootViewController {
                        self.showAd(from: rootVC)
                        self.shouldShowAtStartup = false
                    }
                }
            }
        }
    }

    func showAd(from rootViewController: UIViewController? = nil) {
        guard let ad = interstitial, !isAdShowing else { return }

        isAdShowing = true

        let rootVC = rootViewController ??
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?.rootViewController

        if let rootVC = rootVC {
            ad.present(from: rootVC)
            interstitial = nil
        }
    }

    func shouldShowAdAfterPageChange() -> Bool {
        pageCounter += 1
        print("🔁 Navigation \(pageCounter)")
        return pageCounter % 3 == 0 && interstitial != nil && !isAdShowing
    }

    // ✅ Reset après la pub
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📭 Pub terminée")
        isAdShowing = false
        loadAd()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ Pub erreur affichage : \(error.localizedDescription)")
        isAdShowing = false
        loadAd()
    }
    func showAdOnceIfPossible(from rootVC: UIViewController?) {
        guard !isAdShowing, let ad = interstitial else { return }

        isAdShowing = true
        ad.present(from: rootVC ?? UIViewController())
    }
}
