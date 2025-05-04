//
//  QuranLoader.swift
//  QuranApp
//
//  Created by abbas on 03/05/2025.
//


import Foundation


class QuranLoader {
    static func loadQuran() -> [Surah] {
        guard let url = Bundle.main.url(forResource: "quran_ar_en_fr", withExtension: "json"),
              
              let data = try? Data(contentsOf: url),
              let surahs = try? JSONDecoder().decode([Surah].self, from: data) else {
            print("Erreur lors du chargement du fichier JSON")
            return []
        }
        return surahs
    }
}
