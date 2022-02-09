import Foundation

struct OpenMarketAPI {
    static let shared = OpenMarketAPI()
    let connector = URLConnector(baseURL: "https://market-training.yagom-academy.kr/")
    
    private init() {}
    
    func checkAPIStatus() {
        connector.checkHTTPResponse(url: "healthChecker")
    }
    
    func getProductList(numberOfPage: Int, itemsPerPage: Int) {
        connector.getData(from: "api/products?page_no=\(numberOfPage)&items_per_page=\(itemsPerPage)", type: Products.self)
    }
    
    func getDetailOfProduct(productId: Int) {
        connector.getData(from: "api/products/\(productId)", type: Product.self)
    }
    
    func addProduct(data: inout [String: String], images: inout [Data]) {
        connector.postData(to: "api/products/", data: &data, images: &images)
    }
}
