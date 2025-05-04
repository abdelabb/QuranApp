import Foundation

/// Conteneur racine
struct HadithAPIResponse: Codable {
    let status: Int
    let message: String
    let hadiths: HadithList
}

/// Liste paginée de hadiths
struct HadithList: Codable {
    let current_page: Int
    let data: [HadithItem]
}

/// Représente un hadith complet
struct HadithItem: Codable {
    let id: Int
    let hadithNumber: String
    let hadithArabic: String?
    let hadithEnglish: String?
    let hadithFrench: String?  // ✅ Nouveau champ

    enum CodingKeys: String, CodingKey {
        case id
        case hadithNumber
        case hadithArabic
        case hadithEnglish
        case hadithFrench = "hadithFrench" // <- doit correspondre au JSON
    }
}

/// Format intermédiaire pour l’affichage dans la vue
struct HadithDetail {
    let arab: String
    let english: String?
    let french: String?
    let source: String
}
