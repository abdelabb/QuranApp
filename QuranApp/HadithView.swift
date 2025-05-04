import SwiftUI

struct HadithView: View {
    @State private var hadith: HadithDetail?
    @State private var isLoading: Bool = true
    @State private var errorText: String?
    @AppStorage("quranLanguage") private var lang: String = "ar"

    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Chargement…")
            }
            else if let h = hadith {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Hadith du jour")
                            .font(.headline)

                        Text(lang == "ar" ? "🇸🇦 En arabe" : lang == "fr" ? "🇫🇷 En français" : "🇬🇧 In English")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        // Texte principal selon la langue sélectionnée
                        Text(getLocalizedHadithText(h))
                            .font(.body)
                            .multilineTextAlignment(lang == "ar" ? .trailing : .leading)
                            .padding()

                        Text(h.source)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
            else if let err = errorText {
                VStack(spacing: 12) {
                    Text("⚠️ Erreur :")
                        .font(.title3).bold()
                    Text(err)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Réessayer") {
                        loadHadith()
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .onAppear(perform: loadHadith)
        .navigationTitle("Hadith")
    }

    private func loadHadith() {
        isLoading = true
        errorText = nil
        hadith = nil

        HadithService.shared.fetchRandomHadith { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let detail):
                    hadith = detail
                case .failure(let err):
                    errorText = err.localizedDescription
                }
            }
        }
    }

    // 🧠 Retourne le texte du hadith selon la langue
    private func getLocalizedHadithText(_ h: HadithDetail) -> String {
        switch lang {
        case "ar": return h.arab
        case "fr": return h.french ?? "[Pas de traduction en français]"
        case "en": fallthrough
        default: return h.english ?? "[No English translation]"
        }
    }
}
