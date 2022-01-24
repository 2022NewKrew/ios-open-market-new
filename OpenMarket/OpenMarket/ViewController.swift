import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let server = Server(connector: Connector())
//        Server.shared.checkAPIStatus()
//        Server.shared.getProductList(numberOfPage: 1, itemsPerPage: 10)
//        Server.shared.getDetailOfProduct(productId: 1004)
//        server.checkAPIStatus()
        server.getProductList(numberOfPage: 1, itemsPerPage: 10)
//        server.getDetailOfProduct(productId: 1004)
    }
}

