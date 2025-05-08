import AVFoundation
import Foundation
import Combine

class AudioPlayer: ObservableObject {
    var player: AVAudioPlayer?
    var timer: Timer?

    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    @Published var isLoading: Bool = false
    @Published var isPlaying: Bool = false

    func playAudio(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        isLoading = true

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.player = try? AVAudioPlayer(data: data)
                    self.player?.prepareToPlay()
                    self.player?.play()
                    self.duration = self.player?.duration ?? 1
                    self.isPlaying = true
                    self.startTimer()
                    self.isLoading = false
                }
            } catch {
                print("Erreur de téléchargement : \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    func playSurah(named surahName: String) {
        isLoading = true

        if let url = Bundle.main.url(forResource: surahName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                restorePlaybackPosition(for: surahName)
                player?.play()
                isPlaying = true
                duration = player?.duration ?? 1
                startTimer()
                isLoading = false
            } catch {
                print("Erreur lecture : \(error.localizedDescription)")
                isLoading = false
            }
        } else {
            print("Fichier \(surahName).mp3 non trouvé.")
            isLoading = false
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
    }

    func resume() {
        player?.play()
        isPlaying = true
        startTimer()
    }

    func stop() {
        player?.stop()
        isPlaying = false
        timer?.invalidate()
        currentTime = 0
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.currentTime = self.player?.currentTime ?? 0
        }
    }

    func savePlaybackPosition(for surah: String) {
        UserDefaults.standard.set(currentTime, forKey: "position_\(surah)")
    }

    func restorePlaybackPosition(for surah: String) {
        let savedTime = UserDefaults.standard.double(forKey: "position_\(surah)")
        player?.currentTime = savedTime
        currentTime = savedTime
    }
}
