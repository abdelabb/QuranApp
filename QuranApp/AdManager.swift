import GoogleMobileAds
import SwiftUI

class AdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private var interstitial: InterstitialAd?
    private var isAdShowing = false
    private(set) var pageCounter = 0

    // ✅ Remplace l'ID test par ton ID réel AdMob
    private let adUnitID = "ca-app-pub-4597213075644517/3204231886" // <- Ton vrai ID

    override init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Erreur pub : \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
            print("✅ Pub chargée")
        }
    }

    func showAdOnceIfPossible(from rootVC: UIViewController) {
        guard let ad = interstitial, !isAdShowing else {
            print("⛔️ Pub pas prête ou déjà affichée")
            return
        }
        isAdShowing = true
        ad.present(from: rootVC)
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("👋 Pub fermée")
        isAdShowing = false
        loadAd()
    }

    func shouldShowAdAfterPageChange() -> Bool {
        pageCounter += 1
        print("🔁 Navigation \(pageCounter)")
        return pageCounter % 3 == 0
    }
}
