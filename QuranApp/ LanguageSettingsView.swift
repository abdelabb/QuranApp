//
//   LanguageSettingsView.swift
//  QuranApp
//
//  Created by abbas on 04/05/2025.
//

import SwiftUI

struct LanguageSettingsView: View {
    @Binding var lang: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Langue du Coran")) {
                    Picker("Langue", selection: $lang) {
                        Text("Arabe").tag("ar")
                        Text("Anglais").tag("en")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
