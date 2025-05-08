import SwiftUI

struct SurahDetailView: View {
    let surah: Surah
    @StateObject var audioPlayer = AudioPlayer()

    // Langue sélectionnée ("ar", "fr", "en")
    @AppStorage("quranLanguage") private var lang: String = "ar"
    @AppStorage("fontSize") private var fontSize: Double = 18

    var body: some View {
        ScrollView {
            VStack(alignment: lang == "ar" ? .trailing : .leading, spacing: 16) {
                audioControls
                verseList
            }
            .padding()
        }
        .navigationTitle(displayedSurahName)
        .onDisappear {
            let surahName = String(format: "%03d", surah.id)
            audioPlayer.savePlaybackPosition(for: surahName)
            audioPlayer.stop()
        }
    }


    private var audioControls: some View {
        HStack(spacing: 20) {
            // Play/Pause
            Button(action: {
                if audioPlayer.isPlaying {
                    audioPlayer.pause()
                } else {
                    let surahName = String(format: "%03d", surah.id)
                    audioPlayer.playSurah(named: surahName)
                }
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(audioPlayer.isPlaying ? .orange : .blue)
            }

            // Stop
            Button(action: {
                audioPlayer.stop()
            }) {
                Image(systemName: "stop.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
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
            // Texte arabe (toujours affiché)
            Text("\(verse.id). \(verse.textAr)")
                .foregroundColor(.primary)
                .font(.system(size: fontSize))
                .multilineTextAlignment(.leading)

            // Traduction selon la langue sélectionnée
            if lang != "ar" {
                Text(displayedText(for: verse))
                    .foregroundColor(.secondary)
                    .font(.system(size: fontSize - 2))
                    .italic()
                    .multilineTextAlignment(.leading)
            }

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
                let sharedText = "\(verse.textAr)\n\(displayedText(for: verse))"
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
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 0.5)
    }

    // Fonction pour choisir le texte selon la langue
    private func displayedText(for verse: Verse) -> String {
        switch lang {
        case "fr": return verse.textFr
        case "en": return verse.textEn
        default: return verse.textAr
        }
    }
    private var displayedSurahName: String {
        switch lang {
        case "fr": return surah.transliteration
        case "en": return surah.translation
        default: return surah.name
        }
    }
}
