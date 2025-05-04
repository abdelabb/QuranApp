import SwiftUI

struct ContentView: View {
    @AppStorage("quranLanguage") private var lang: String = "ar"
    @State private var showingSettings = false

    var body: some View {
        NavigationStack { // 🔁 ici on entoure TabView dans NavigationStack
            TabView {
                QuranView()
                    .tabItem { Label("Coran", systemImage: "book") }
                QiblaView()
                    .tabItem { Label("Qibla", systemImage: "location.north.line") }
                HadithView()
                    .tabItem { Label("Hadith", systemImage: "quote.bubble") }
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
                        Picker("", selection: $lang) {
                            Text("العربية").tag("ar")
                            Text("English").tag("en")
                            Text("Français").tag("fr")
                        }
                            .pickerStyle(.segmented)
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


#Preview {
    ContentView()
}
