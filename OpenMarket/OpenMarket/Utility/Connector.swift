import Foundation

struct Connector {
    let ROOT = "https://market-training.yagom-academy.kr/"
    static let shared = Connector()
    
    private init() {}
    
    func get<T: Decodable> (from: String, type: T.Type) {
        var request = URLRequest(url: URL(string: ROOT + from)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        sleep(2000)
    }
}
