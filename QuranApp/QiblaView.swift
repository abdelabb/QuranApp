import SwiftUI

struct QiblaView: View {
    @StateObject private var qiblaManager = QiblaManager()

    var body: some View {
        VStack(spacing: 32) {
            Text("Direction de la Qibla")
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

            Text("🕋 Qibla à \(Int(qiblaManager.qiblaDirection))°")
                .font(.headline)

            if abs(qiblaManager.qiblaDirection - qiblaManager.userHeading) > 10 {
                Text("Tourne ton téléphone vers la Qibla")
                    .foregroundColor(.red)
                    .font(.caption)
            } else {
                Text("Parfait ! Tu es orienté vers la Qibla")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding()
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
