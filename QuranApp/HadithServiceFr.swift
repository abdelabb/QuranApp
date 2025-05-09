import Foundation

class HadithServiceFr: ObservableObject {
    @Published var hadith: HadithFr? = nil

    func fetchRandomHadith(language: String = "fr", categoryID: String = "85") {
        guard let listURL = URL(string: "https://hadeethenc.com/api/v1/hadeeths/list/?language=\(language)&category_id=\(categoryID)") else {
            print("❌ URL invalide (liste)")
            return
        }

        URLSession.shared.dataTask(with: listURL) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(HadithListResponse.self, from: data)
                    if let randomID = decoded.data.randomElement()?.id {
                        self.fetchHadithDetails(id: randomID, language: language)
                    }
                } catch {
                    print("❌ Erreur parsing liste : \(error)")
                }
            } else if let error = error {
                print("❌ Erreur réseau (liste) : \(error)")
            }
        }.resume()
    }

    private func fetchHadithDetails(id: String, language: String) {
        guard let detailURL = URL(string: "https://hadeethenc.com/api/v1/hadeeths/one/?language=\(language)&id=\(id)") else {
            print("❌ URL invalide (détail)")
            return
        }

        URLSession.shared.dataTask(with: detailURL) { data, _, error in
            if let data = data {
                do {
                    // 🔁 decode directement en HadithFr
                    let decoded = try JSONDecoder().decode(HadithFr.self, from: data)
                    DispatchQueue.main.async {
                        self.hadith = decoded
                    }
                } catch {
                    print("❌ Erreur parsing détail : \(error)")
                    print("📦 JSON : \(String(data: data, encoding: .utf8) ?? "nil")")
                }
            } else if let error = error {
                print("❌ Erreur réseau (détail) : \(error)")
            }
        }.resume()
    }
}
