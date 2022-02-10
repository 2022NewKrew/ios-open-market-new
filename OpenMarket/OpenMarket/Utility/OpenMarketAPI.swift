import Foundation

struct OpenMarketAPI {
    static let shared = OpenMarketAPI()
    let connector = URLConnector(baseURL: "https://market-training.yagom-academy.kr/")
    
    private init() {}
    
    func checkAPIStatus() {
        connector.checkHTTPResponse(url: "healthChecker")
    }
    
    func getProductList(numberOfPage: Int, itemsPerPage: Int) {
        connector.getData(from: "api/products?page_no=\(numberOfPage)&items_per_page=\(itemsPerPage)", type: Products.self, name: "ProductList")
    }
    
    func getDetailOfProduct(productId: Int) {
        connector.getData(from: "api/products/\(productId)", type: Product.self, name: "ProductDetail")
    }
    
    func addProduct(data: inout [String: String], images: inout [Data]) {
        connector.postData(to: "api/products/",
                           data: &data, images: &images,
                           name: "AddResponse")
    }
    
    func getProductSecret(productId: Int) {
        var tempData: [String: String] = [:]
        var tempImage: [Data] = []
        connector.postData(to: "api/products/\(productId)/secret",
                           data: &tempData, images: &tempImage,
                           name: "ProductSecret")
    }
    
    func deleteProduct(productId: Int, secret: String) {
        connector.deleteData(to: "api/products/\(productId)/\(secret)")
    }
}
