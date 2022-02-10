import Foundation

struct URLConnector {
    let baseURL: String
    let identifier: String = "8db5350d-7217-11ec-abfa-ab5fb16f056f"
    let secret: String = "#QRgn&=SUfPUR@2Z"
    
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
    
    func getData<T: Decodable> (from url: String, type: T.Type, name: String) {
        guard let targetURL = URL(string: baseURL + url) else { return }
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                print(String.init(data: data, encoding: .utf8)!)
                guard let parsedData = Decoder.shared.decodeJSONData(type: type, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: ["\(type)": parsedData])
            }
            
        }
        task.resume()
    }
    
    func postData(to url: String, data: inout [String: String], images: inout [Data]) {
        guard let targetURL = URL(string: baseURL + url) else { return }
        let boundary = "Boundary-\(UUID().uuidString)"
        data["secret"] = secret
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(json: data, images: images, boundary: boundary)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                print(String.init(data: data, encoding: .utf8)!)
                guard let parsedData = Decoder.shared.decodeJSONData(type: Product.self, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name("PostResponse"), object: nil, userInfo: ["data": parsedData])
            }
            
        }
        task.resume()
    }

    func createBody(json: [String: Any], images: [Data], boundary: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition:form-data; name=\"params\"".data(using: .utf8)!)
        body.append("; filename=\"params.json\"\r\nContent-Type: application/json\r\n\r\n".data(using: .utf8)!)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        body.append(jsonData ?? Data())
        body.append("\r\n".data(using: .utf8)!)
        for image in images {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition:form-data; name=\"images\"".data(using: .utf8)!)
            body.append("; filename=\"image.png\"\r\nContent-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(image)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body as Data
    }
}
