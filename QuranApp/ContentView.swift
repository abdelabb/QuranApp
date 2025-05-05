import SwiftUI

struct ContentView: View {
    @AppStorage("quranLanguage") private var lang: String = "ar"
    @AppStorage("fontSize") private var fontSize: Double = 18
    @State private var showingSettings = false

    var body: some View {
        NavigationStack { // 🔁 ici on entoure TabView dans NavigationStack
            TabView {
                QuranView()
                    .tabItem {
                        Image(systemName: "book")
                        Text(tabTitle("quran"))
                    }
                QiblaView()
                    .tabItem {
                               Image(systemName: "location.north.line")
                               Text(tabTitle("qibla"))
                           }
                HadithView()
                    .tabItem {
                                Image(systemName: "quote.bubble")
                                Text(tabTitle("hadith"))
                            }
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
        }
    func tabTitle(_ key: String) -> String {
        switch lang {
        case "fr":
            return ["quran": "Coran", "qibla": "Qibla", "hadith": "Hadith"][key] ?? key
        case "en":
            return ["quran": "Quran", "qibla": "Qibla", "hadith": "Hadith"][key] ?? key
        default: // "ar"
            return ["quran": "القرآن", "qibla": "القبلة", "hadith": "الحديث"][key] ?? key
        }
    }
    }


#Preview {
    ContentView()
}
