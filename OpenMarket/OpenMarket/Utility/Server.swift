import Foundation

struct Server {
    let connector: Connector
    
    init(connector: Connector) {
        self.connector = connector
    }
    
    func checkAPIStatus() {
        connector.check()
    }
    
    func getProductList(numberOfPage: Int, itemsPerPage: Int) {
        connector.get(from: "api/products?page_no=\(numberOfPage)&items_per_page=\(itemsPerPage)", type: Products.self)
    }
    
    func getDetailOfProduct(productId: Int) {
        connector.get(from: "api/products/\(productId)", type: Product.self)
    }
}
