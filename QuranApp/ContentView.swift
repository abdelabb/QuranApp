import SwiftUI

struct ContentView: View {
    @AppStorage("quranLanguage") private var lang: String = "ar"
    @AppStorage("fontSize") private var fontSize: Double = 18
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false

    @State private var showingSettings = false
    @State private var showWelcomeAlert = false
    @State private var selectedTab = 0

    @StateObject private var adManager = AdManager()

    var body: some View {
        NavigationStack {
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

                // ✅ Bannière en bas
                BannerAdView(adUnitID: "ca-app-pub-4597213075644517/6104909155")
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
                NavigationStack {
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
            if !hasLaunchedBefore {
                if let deviceLang = Locale.current.languageCode {
                    lang = ["fr", "en"].contains(deviceLang) ? deviceLang : "ar"
                }
                hasLaunchedBefore = true
                showWelcomeAlert = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let rootVC = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows.first?.rootViewController {
                    // ✅ Afficher pub qu’une fois au démarrage
                    if adManager.pageCounter == 0 {
                        adManager.showAdOnceIfPossible(from: rootVC)
                    }
                }
            }
        }

        .alert(isPresented: $showWelcomeAlert) {
            Alert(
                title: Text(welcomeTitle()),
                message: Text(welcomeMessage()),
                dismissButton: .default(Text("OK"))
            )
        }
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

#Preview {
    ContentView()
}
