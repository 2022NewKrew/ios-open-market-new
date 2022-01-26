import Foundation

struct URLConnector {
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func checkHTTPResponse(url: String) {
        var request = URLRequest(url: URL(string: baseURL + url)!)
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
    
    func get<T: Decodable> (from url: String, type: T.Type) {
        var request = URLRequest(url: URL(string: baseURL + url)!)
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
