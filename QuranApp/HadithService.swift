import Foundation

class HadithService {
  static let shared = HadithService()
  private let apiKey = "$2y$10$DrGT6Z8LqjMUzBIzlGir5jWbowum9NRGaNxvUHAiEXauQloAA"

  func fetchRandomHadith(completion: @escaping (Result<HadithDetail, Error>) -> Void) {
    // 1) Construction de l’URL avec URLComponents
    var comp = URLComponents()
    comp.scheme = "https"
    comp.host   = "hadithapi.com"
    comp.path   = "/api/hadiths"
    comp.queryItems = [
      URLQueryItem(name: "apiKey",    value: apiKey),        // ta clé
      URLQueryItem(name: "livre",      value: "muslim"),      // « muslim »
      URLQueryItem(name: "paginer",  value: "50"),          // nombre max
      // tu peux ajouter chapter, status, etc.
    ]

    guard let url = comp.url else {
      return completion(.failure(NSError(domain: "urlError", code: -1)))
    }

    // 2) Appel réseau
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        return completion(.failure(error))
      }
      guard let data = data else {
        return completion(.failure(NSError(domain: "dataError", code: -1)))
      }

      do {
        // 3) Décodage
        let apiResponse = try JSONDecoder().decode(HadithAPIResponse.self, from: data)

        // 4) On prend un hadith aléatoire dans la liste
        let items = apiResponse.hadiths.data
        if let random = items.randomElement() {
            
            let detail = HadithDetail(
                arab: random.hadithArabic ?? "[— pas d’arabe —]",
                english: random.hadithEnglish,
                french: random.hadithFrench, // ✅ ajoute ceci
                source: "Muslim #\(random.hadithNumber)"
            )
          completion(.success(detail))
        } else {
          completion(.failure(NSError(domain: "noHadiths", code: -2)))
        }

      } catch {
        // Pour débug, on loggue le JSON brut
        if let str = String(data: data, encoding: .utf8) {
          print("🔍 JSON reçu :", str)
        }
        completion(.failure(error))
      }
    }.resume()
  }
}
