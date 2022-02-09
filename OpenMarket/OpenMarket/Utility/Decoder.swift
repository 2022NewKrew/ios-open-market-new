import Foundation
import UIKit

struct Decoder {
    static let shared = Decoder()
    
    private init() {}
    
    func decodeJSONData<T: Decodable> (type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}
