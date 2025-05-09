import Foundation

// /list
struct HadithListItem: Codable, Identifiable {
    let id: String
    let title: String
}

// /one — correspond à la réponse complète directement
struct HadithFr: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let hadeeth: String
    let attribution: String
    let explanation: String?
    let grade: String?
    let book: String?
    let number: String?
}

// Réponse /list
struct HadithListResponse: Codable {
    let data: [HadithListItem]
}
