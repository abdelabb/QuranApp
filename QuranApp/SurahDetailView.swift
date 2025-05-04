import SwiftUI

struct SurahDetailView: View {
    let surah: Surah
    @StateObject var audioPlayer = AudioPlayer()

    // Langue sélectionnée ("ar", "fr", "en")
    @AppStorage("quranLanguage") private var lang: String = "ar"

    var body: some View {
        ScrollView {
            VStack(alignment: lang == "ar" ? .trailing : .leading, spacing: 16) {
                surahHeader
                audioControls
                verseList
            }
            .padding()
        }
        .navigationTitle(surah.name)
        .onDisappear {
            let surahName = String(format: "%03d", surah.id)
            audioPlayer.savePlaybackPosition(for: surahName)
            audioPlayer.stop()
        }
    }

    private var surahHeader: some View {
        Button(action: {
            let surahName = String(format: "%03d", surah.id)
            audioPlayer.playSurah(named: surahName)
        }) {
            Label("Écouter la sourate complète", systemImage: "play.fill")
                .foregroundColor(.green)
        }
    }

    private var audioControls: some View {
        HStack(spacing: 20) {
            Button(action: { audioPlayer.pause() }) {
                Label("Pause", systemImage: "pause.fill")
                    .foregroundColor(.orange)
            }
            Button(action: { audioPlayer.resume() }) {
                Label("Reprendre", systemImage: "play.circle.fill")
                    .foregroundColor(.blue)
            }
            Button(action: { audioPlayer.stop() }) {
                Label("Arrêter", systemImage: "stop.fill")
                    .foregroundColor(.red)
            }
        }
    }

    private var verseList: some View {
        ForEach(surah.verses) { verse in
            verseView(for: verse)
        }
    }

    private func verseView(for verse: Verse) -> some View {
        VStack(alignment: lang == "ar" ? .trailing : .leading, spacing: 8) {
            // Texte dans la langue choisie
            Text("\(verse.id). \(displayedText(for: verse))")
                .multilineTextAlignment(lang == "ar" ? .trailing : .leading)

            // Bouton audio
            Button(action: {
                let surahID = String(format: "%03d", surah.id)
                let verseID = String(format: "%03d", verse.id)
                let url = "https://verses.quran.com/AbdulBaset/Mujawwad/mp3/\(surahID)\(verseID).mp3"
                audioPlayer.playAudio(from: url)
            }) {
                Label("Écouter", systemImage: "play.circle.fill")
                    .foregroundColor(.blue)
            }

            // Bouton partage
            Button(action: {
                let sharedText = displayedText(for: verse)
                let activityVC = UIActivityViewController(activityItems: [sharedText], applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(activityVC, animated: true)
                }
            }) {
                Label("Partager", systemImage: "square.and.arrow.up")
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    // Fonction pour choisir le texte selon la langue
    private func displayedText(for verse: Verse) -> String {
        switch lang {
        case "fr": return verse.textFr
        case "en": return verse.textEn
        default: return verse.textAr
        }
    }
}
