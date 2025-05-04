import SwiftUI

struct QuranView: View {
    let surahs = QuranLoader.loadQuran()
    @AppStorage("quranLanguage") private var lang: String = "ar"

    var body: some View {
        NavigationView {
            List(surahs, id: \.id) { surah in
                surahRow(surah)
            }
            .navigationTitle(
                lang == "ar"
                    ? "القرآن الكريم"
                    : "Holy Quran"
            )
        }
    }
    @ViewBuilder
    private func surahRow(_ surah: Surah) -> some View {
        NavigationLink(destination: SurahDetailView(surah: surah)) {
            VStack(alignment: .leading) {
                if lang == "ar" {
                    Text(surah.name) // arabe
                        .font(.body)
                } else {
                    Text(surah.transliteration) // nom en anglais
                        .font(.body)
                }

                Text(surah.transliteration) // traduction française
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
    }
}
