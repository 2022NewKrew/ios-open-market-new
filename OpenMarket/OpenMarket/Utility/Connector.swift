import Foundation

struct Connector {
    let root = "https://market-training.yagom-academy.kr/"
    static let shared = Connector()
    
    private init() {}
    
    func check() {
        var request = URLRequest(url: URL(string: root + "healthChecker")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            if let response = response as? HTTPURLResponse {
                print("status code:", response.statusCode)
            }
        }
        task.resume()
    }
    
    func get<T: Decodable> (from: String, type: T.Type) {
        var request = URLRequest(url: URL(string: root + from)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                guard let parsedData = Decoder.decodeJSONData(type: type, from: data) else { return }
                print(parsedData)
            }
            
        }
        task.resume()
    }
}
