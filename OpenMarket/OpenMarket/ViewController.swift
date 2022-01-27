import UIKit

class ViewController: UIViewController {
    lazy var listOrGrid: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemBackground]
        let subTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes(titleTextAttribute, for: .selected)
        segmentedControl.setTitleTextAttributes(subTextAttribute, for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(segmentedControl:)), for: .valueChanged)
        return segmentedControl
    }()
    
    var products: [Product] = []
    let tableView: UITableView = UITableView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    @objc
    func segmentedControlChanged(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            collectionView.isHidden = true
            tableView.reloadData()
        case 1:
            tableView.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: Notification.Name("GET"), object: nil)
        navigationItem.titleView = listOrGrid
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
        OpenMarketAPI.shared.getProductList(numberOfPage: 1, itemsPerPage: 20)
        // index에따라..
        view.addSubview(tableView)
        view.addSubview(collectionView)
        collectionView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.safeAreaLayoutGuide.layoutFrame
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc
    func reloadData(_ notification: NSNotification) {
        print("reloaded")
        let loadedData = notification.userInfo?["GET"] as! Products
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

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell ?? GridCollectionViewCell()
        cell.setupCell(data: products[indexPath.row])
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32 )/2
        let height = collectionView.frame.height / 3 - 1
        return CGSize(width: width, height: height)
    }
    
    
}
