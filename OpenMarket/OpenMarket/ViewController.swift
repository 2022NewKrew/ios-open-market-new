import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Server.shared.checkAPIStatus()
        Server.shared.getProductList(numberOfPage: 1, itemsPerPage: 10)
        Server.shared.getDetailOfProduct(productId: 1004)
    }
}

