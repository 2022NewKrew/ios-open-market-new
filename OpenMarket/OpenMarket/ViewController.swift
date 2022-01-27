import UIKit

class ViewController: UIViewController {
    let listOrGrid: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        let subTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes(titleTextAttribute, for: .selected)
        segmentedControl.setTitleTextAttributes(subTextAttribute, for: .normal)
        return segmentedControl
    }()
    
    var products: [Product] = []
    let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: Notification.Name("GET"), object: nil)
        navigationItem.titleView = listOrGrid
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
        OpenMarketAPI.shared.getProductList(numberOfPage: 1, itemsPerPage: 10)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc
    func reloadData(_ notification: NSNotification) {
        print("reloaded")
        let loadedData = notification.userInfo?["GET"] as! Products
//        print(loadedData.pages)
        products = loadedData.pages
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as? ListTableViewCell ?? ListTableViewCell()
        cell.setListCell(data: products[indexPath.row])
        return cell
    }
}
