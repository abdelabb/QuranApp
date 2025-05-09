import SwiftUI

struct HadithView: View {
    @AppStorage("quranLanguage") private var lang: String = "fr"
    @StateObject private var service = HadithServiceFr()
    @State private var refreshID = UUID() // 🔁 pour forcer un changement

    var body: some View {
        VStack {
            if let hadith = service.hadith {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(hadith.title)
                            .font(.headline)

                        Text(hadith.hadeeth)
                            .font(.body)
                            .multilineTextAlignment(lang == "ar" ? .trailing : .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        if let number = hadith.number {
                            Text("🔢 Hadith n° \(number)")
                                .font(.footnote)
                        }

                        Divider()

//                        if let attribution = hadith.attribution {
                        Text("👤 \(hadith.attribution)")
                                .font(.callout)
//                        }

                        if let grade = hadith.grade {
                            Text("Authenticité : \(grade)")
                                .font(.footnote)
                        }

                        if let book = hadith.book {
                            Text("📚 Livre : \(book)")
                                .font(.footnote)
                        }

                        if let explanation = hadith.explanation {
                            Divider()
                            Text("💬 \(explanation)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            } else {
                ProgressView("Chargement…")
            }
        }
        .id(refreshID) // 🧠 Redessine la vue quand l'ID change
        .onAppear {
            refreshID = UUID() // ⬅️ force le refresh à chaque retour
            service.fetchRandomHadith(language: lang, categoryID: "85")
        }
        .onChange(of: lang) { newLang in
            service.fetchRandomHadith(language: newLang, categoryID: "85")
        }
    }
}
