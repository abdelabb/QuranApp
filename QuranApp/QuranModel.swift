import Foundation

struct Verse: Codable, Identifiable {
    let id: Int
    let textAr: String
    let textFr: String
    let textEn: String
}


struct Surah: Codable, Identifiable {
    let id: Int
    let name: String
    let transliteration: String
    let translation: String
    let type: String
    let total_verses: Int
    let verses: [Verse]
}
