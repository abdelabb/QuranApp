import SwiftUI

struct QiblaView: View {
    @StateObject private var qiblaManager = QiblaManager()
    @AppStorage("quranLanguage") private var lang: String = "ar"


    var body: some View {
        VStack(spacing: 32) {
            Text(localized("title"))
                .font(.title2)
                .bold()

            ZStack {
                // Cercle de boussole avec points cardinaux
                Circle()
                    .strokeBorder(Color.gray.opacity(0.4), lineWidth: 2)
                    .frame(width: 280, height: 280)

                // Repères cardinaux
                CompassLabels()

                // Flèche vers la Qibla
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                    .rotationEffect(
                        Angle(degrees: qiblaManager.qiblaDirection - qiblaManager.userHeading)
                    )
                    .animation(.easeInOut(duration: 0.3), value: qiblaManager.qiblaDirection - qiblaManager.userHeading)

                // Centre de la boussole
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
            }

            Text("🕋 \(localized("qiblaAt")) \(Int(qiblaManager.qiblaDirection))°")
                .font(.headline)

            if abs(qiblaManager.qiblaDirection - qiblaManager.userHeading) > 10 {
                Text(localized("turnPhone"))
                    .foregroundColor(.red)
                    .font(.caption)
            } else {
                Text(localized("perfect"))
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding()
    }
    private func localized(_ key: String) -> String {
        let values: [String: [String: String]] = [
            "title": ["fr": "Direction de la Qibla", "en": "Qibla Direction", "ar": "اتجاه القبلة"],
            "qiblaAt": ["fr": "Qibla à", "en": "Qibla at", "ar": "القبلة عند"],
            "turnPhone": ["fr": "Tourne ton téléphone vers la Qibla", "en": "Turn your phone toward the Qibla", "ar": "وجّه هاتفك نحو القبلة"],
            "perfect": ["fr": "Parfait ! Tu es orienté vers la Qibla", "en": "Perfect! You're facing the Qibla", "ar": "رائع! أنت متجه نحو القبلة"]
        ]
        return values[key]?[lang] ?? key
    }
}

struct CompassLabels: View {
    var body: some View {
        ZStack {
            Text("N")
                .font(.caption)
                .position(x: 140, y: 10)
            Text("S")
                .font(.caption)
                .position(x: 140, y: 270)
            Text("E")
                .font(.caption)
                .position(x: 270, y: 140)
            Text("O")
                .font(.caption)
                .position(x: 10, y: 140)
        }
        .frame(width: 280, height: 280)
    }
}
