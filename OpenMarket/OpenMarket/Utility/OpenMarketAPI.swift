import Foundation

struct OpenMarketAPI {
    static let shared = OpenMarketAPI()
    let connector = URLConnector(baseURL: "https://market-training.yagom-academy.kr/")
    
    private init() {}
    
    func checkAPIStatus() {
        connector.checkHTTPResponse(url: "healthChecker")
    }
    
    func getProductList(numberOfPage: Int, itemsPerPage: Int) {
        connector.get(from: "api/products?page_no=\(numberOfPage)&items_per_page=\(itemsPerPage)", type: Products.self)
    }
    
    func getDetailOfProduct(productId: Int) {
        connector.get(from: "api/products/\(productId)", type: Product.self)
    }
}
