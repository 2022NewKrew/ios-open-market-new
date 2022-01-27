import UIKit

class ViewController: UIViewController {
    // MARK: - UI componets
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
    
    let listView: UITableView = UITableView()
    let gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Property
    var products: [Product] = []
    var isLoading: Bool = true
    var currentPage: Int = 1
    var hasNextPage: Bool = true
    let itemsPerPage: Int = 20
    
    // MARK: - Override function
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(_:)), name: Notification.Name("LoadData"), object: nil)
        setupNavigationBar()
        setupTableView()
        setupCollectionView()
        setupActivityIndicator()
        OpenMarketAPI.shared.getProductList(numberOfPage: currentPage, itemsPerPage: itemsPerPage)
    }
    
    // MARK: - objc function
    @objc
    func reloadData(_ notification: NSNotification) {
        let loadedData = notification.userInfo?["data"] as! Products
        products += loadedData.pages
        hasNextPage = loadedData.hasNext
        DispatchQueue.main.async {
            self.segmentedControlChanged(segmentedControl: self.listOrGrid)
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc
    func segmentedControlChanged(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listView.isHidden = false
            gridView.isHidden = true
            listView.reloadData()
        case 1:
            listView.isHidden = true
            gridView.isHidden = false
            gridView.reloadData()
        default:
            return
        }
    }
    
    //MARK: - function
    func setupNavigationBar() {
        navigationItem.titleView = listOrGrid
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: nil)
    }
    
    func setupTableView() {
        view.addSubview(listView)
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.delegate = self
        listView.dataSource = self
        listView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupCollectionView() {
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.isHidden = true
        gridView.delegate = self
        gridView.dataSource = self
        gridView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            gridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
}

// MARK: - TableView
extension ViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && hasNextPage {
            self.currentPage += 1
            OpenMarketAPI.shared.getProductList(numberOfPage: currentPage, itemsPerPage: itemsPerPage)
            self.activityIndicator.startAnimating()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as? ListTableViewCell ?? ListTableViewCell()
        cell.setListCell(data: products[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell ?? GridCollectionViewCell()
        cell.setupCell(data: products[indexPath.row])
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40 )/2
        let height = (collectionView.frame.height - 16) / 3
        return CGSize(width: width, height: height)
    }
}
