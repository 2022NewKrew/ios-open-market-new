import Foundation

struct URLConnector {
    let baseURL: String
    let identifier: String = "8db5350d-7217-11ec-abfa-ab5fb16f056f"
    let secret: String = "#QRgn&=SUfPUR@2Z"
    let boundary = "Boundary-\(UUID().uuidString)"
    
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
                guard let parsedData = Decoder.shared.decodeJSONData(type: type, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: ["\(type)": parsedData])
            }
            
        }
        task.resume()
    }
    
    func postData(to url: String, data: inout [String: String],
                  images: inout [Data]) {
        guard let targetURL = URL(string: baseURL + url) else { return }
        data["secret"] = secret
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        addJsonToBody(body: &body, json: data)
        addImageToBody(body: &body, images: images)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                guard let parsedData = Decoder.shared.decodeJSONData(type: Product.self, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name("PostResponse"), object: nil, userInfo: ["data": parsedData])
            }
            
        }
        task.resume()
    }
    
    func deleteData(to url: String) {
        guard let targetURL = URL(string: baseURL + url) else { return }
        var request = URLRequest(url: targetURL)
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                print(String.init(data: data, encoding: .utf8)!)
                guard let parsedData = Decoder.shared.decodeJSONData(type: Product.self, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name("DeleteResponse"), object: nil, userInfo: ["data": parsedData])
            }
            
        }
        task.resume()
    }
    
    func patchData(to url: String, data: inout [String: String]) {
        guard let targetURL = URL(string: baseURL + url) else { return }
        var request = URLRequest(url: targetURL)
        request.addValue(identifier, forHTTPHeaderField: "identifier")
        request.httpMethod = "PATCH"
        var params = "{\n    \"secret\": \"\(secret)\""
        for (key, value) in data {
            params += ",\n    \"\(key)\": \"\(value)\""
        }
        params += "\n}"
        request.httpBody = params.data(using: .utf8)!
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                print(String.init(data: data, encoding: .utf8)!)
                guard let parsedData = Decoder.shared.decodeJSONData(type: Product.self, from: data) else { return }
                NotificationCenter.default.post(name: Notification.Name("PatchResponse"), object: nil, userInfo: ["data": parsedData])
            }
            
        }
        task.resume()
    }
    
    func addJsonToBody(body: inout Data, json: [String: Any]) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition:form-data; name=\"params\"".data(using: .utf8)!)
        body.append("; filename=\"params.json\"\r\nContent-Type: application/json\r\n\r\n".data(using: .utf8)!)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        body.append(jsonData ?? Data())
        body.append("\r\n".data(using: .utf8)!)
    }
    
    func addImageToBody(body: inout Data, images: [Data]) {
        for image in images {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition:form-data; name=\"images\"".data(using: .utf8)!)
            body.append("; filename=\"image.png\"\r\nContent-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(image)
            body.append("\r\n".data(using: .utf8)!)
        }
    }
}
