import Foundation

class Connector {
    let ROOT = "https://market-training.yagom-academy.kr/"
    static let shared = Connector()
    
    private init() {}
    
    func get(from: String) {
        var request = URLRequest(url: URL(string: ROOT + from)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        sleep(2000)
    }
}
