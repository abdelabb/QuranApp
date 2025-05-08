//
//  RateAppCard.swift.swift
//  QuranApp
//
//  Created by abbas on 08/05/2025.
//


import SwiftUI
import StoreKit

struct RateAppCard: View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Aimes-tu cette application ?")
                .font(.headline)
            Text("Note-nous sur l’App Store !")
                .font(.subheadline)
                .multilineTextAlignment(.center)

            HStack {
                Button("Plus tard") {
                    onDismiss()
                }
                .foregroundColor(.gray)

                Spacer()

                if #available(iOS 16.0, *) {
                    Button("Noter maintenant") {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                        onDismiss()
                    }
                    .bold()
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 5))
        .padding()
    }
}
