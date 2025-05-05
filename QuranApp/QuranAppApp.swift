import SwiftUI
import GoogleMobileAds

@main
struct QuranAppApp: App {
    init() {
        MobileAds.shared.start(completionHandler: nil)
        //MobileAds.shared.start()
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = ["6abf7ab10106d7a16d623ebba50d24d"]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
