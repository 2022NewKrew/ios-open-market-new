import UIKit

class ViewController: UIViewController {
    let listOrGrid: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        let subTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.backgroundColor = .white // ??
        segmentedControl.setTitleTextAttributes(titleTextAttribute, for: .selected)
        segmentedControl.setTitleTextAttributes(subTextAttribute, for: .normal)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let server = Server(connector: Connector(root: "https://market-training.yagom-academy.kr/"))
//        Server.shared.checkAPIStatus()
//        Server.shared.getProductList(numberOfPage: 1, itemsPerPage: 10)
//        Server.shared.getDetailOfProduct(productId: 1004)
//        server.checkAPIStatus()
//        server.getProductList(numberOfPage: 1, itemsPerPage: 10)
//        server.getDetailOfProduct(productId: 1004)
        navigationItem.titleView = listOrGrid
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
//        navigationItem.title = "adsfg"
//        OpenMarketAPI.shared.getProductList(numberOfPage: 1, itemsPerPage: 10)
    }
}

