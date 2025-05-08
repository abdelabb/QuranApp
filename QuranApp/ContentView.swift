import SwiftUI

struct ContentView: View {
    @AppStorage("quranLanguage") private var lang: String = "ar"
    @AppStorage("fontSize") private var fontSize: Double = 18
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false

    @State private var showingSettings = false
    @State private var showWelcomeAlert = false
    @State private var selectedTab = 0

    @StateObject private var adManager = AdManager()
    @AppStorage("appOpenCount") private var appOpenCount: Int = 0
    @AppStorage("hasRatedApp") private var hasRatedApp: Bool = false
    @State private var showRateCard: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $selectedTab) {
                    QuranView()
                        .tag(0)
                        .tabItem {
                            Image(systemName: "book")
                            Text(tabTitle("quran"))
                        }

                    QiblaView()
                        .tag(1)
                        .tabItem {
                            Image(systemName: "location.north.line")
                            Text(tabTitle("qibla"))
                        }

                    HadithView()
                        .tag(2)
                        .tabItem {
                            Image(systemName: "quote.bubble")
                            Text(tabTitle("hadith"))
                        }
                }
                .onChange(of: selectedTab) { _ in
                    if adManager.shouldShowAdAfterPageChange() {
                        if let rootVC = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows.first?.rootViewController {
                            adManager.showAdOnceIfPossible(from: rootVC)
                        }
                    }
                }

                // ✅ Bannière réelle AdMob en bas
                BannerAdView()
                    .frame(height: 50)
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }

            .sheet(isPresented: $showingSettings) {
                NavigationView {
                    Form {
                        Section("Langue du Coran") {
                            Picker("", selection: $lang) {
                                Text("العربية").tag("ar")
                                Text("English").tag("en")
                                Text("Français").tag("fr")
                            }
                            .pickerStyle(.segmented)
                        }

                        Section("Taille du texte") {
                            Slider(value: $fontSize, in: 14...28, step: 1) {
                                Text("Taille du texte")
                            }
                            Text("Exemple")
                                .font(.system(size: fontSize))
                                .foregroundColor(.gray)
                        }
                    }
                    .navigationTitle("Réglages")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("OK") { showingSettings = false }
                        }
                    }
                }
            }
        }
        .onAppear {
            appOpenCount += 1

              if appOpenCount >= 2 && !hasRatedApp {
                  // Affiche la carte après 5 ouvertures
                  showRateCard = true
              }
            
            if !hasLaunchedBefore {
                if let deviceLang = Locale.current.languageCode {
                    lang = ["fr", "en"].contains(deviceLang) ? deviceLang : "ar"
                }
                showWelcomeAlert = true
            } else {
                adManager.loadAd()
            }
        }
        .alert(isPresented: $showWelcomeAlert) {
            Alert(
                title: Text(welcomeTitle()),
                message: Text(welcomeMessage()),
                dismissButton: .default(Text("OK")) {
                    hasLaunchedBefore = true
                    adManager.loadAd()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let rootVC = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows.first?.rootViewController {
                            adManager.showAdOnceIfPossible(from: rootVC)
                        }
                    }
                }
            )
        }
        .overlay(
            Group {
                if showRateCard {
                    RateAppCard {
                        hasRatedApp = true
                        showRateCard = false
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showRateCard)
                }
            }
        )
    }

    func tabTitle(_ key: String) -> String {
        switch lang {
        case "fr": return ["quran": "Coran", "qibla": "Qibla", "hadith": "Hadith"][key] ?? key
        case "en": return ["quran": "Quran", "qibla": "Qibla", "hadith": "Hadith"][key] ?? key
        default:   return ["quran": "القرآن", "qibla": "القبلة", "hadith": "الحديث"][key] ?? key
        }
    }

    func welcomeTitle() -> String {
        switch lang {
        case "fr": return "Bienvenue !"
        case "en": return "Welcome!"
        default:   return "مرحبًا بك!"
        }
    }

    func welcomeMessage() -> String {
        switch lang {
        case "fr":
            return "Bienvenue sur QuranApp.\nApplication simple pour la lecture et l'écoute du Coran, une Qibla pour vous guider, et un Hadith du jour."
        case "en":
            return "Welcome to QuranApp.\nA simple app for reading and listening to the Quran, a Qibla to guide you, and a Hadith of the day."
        default:
            return "مرحبًا بك في QuranApp.\nتطبيق بسيط لقراءة وسماع القرآن، مع قبلة لتوجيهك، وحديث يومي."
        }
    }
}
