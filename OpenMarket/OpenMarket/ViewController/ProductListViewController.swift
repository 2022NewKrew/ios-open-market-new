//
//  ProductListViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var layoutSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiManager = OpenMarketAPIManager()
    var products: [OpenMarketProduct]?
    private let itemHeightRatio = 0.12
    
    enum SegmentedControlValue: Int {
        case list
        case grid
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setup()
    }
    
    private func setupUI() {
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: view.frame.width, height: 200.0)
        }
    }
    
    private func setup() {
        self.registerCells()
        self.setupDelegate()
    }
    
    private func registerCells() {
        let listCellNibFile = UINib(nibName: Constants.openMarketProcutListCellNibFileName, bundle: nil)
        self.collectionView.register(listCellNibFile, forCellWithReuseIdentifier: Constants.openMarketProductListCellReuseIdentifier)
    }
    
    private func fetchData() {
        apiManager.getOpenMarketProductList(pageNumber: 1, itemsPerPage: 20) { [weak self] result in
            let data = try? result.get()
            guard let products = data?.products else {
                return
            }
            self?.products = products
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupDelegate() {
        self.collectionView.dataSource = self
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.openMarketProductListCellReuseIdentifier,
                for: indexPath) as? OpenMarketProductListCell,
                  let products = products else {
                      return UICollectionViewCell()
                  }
            cell.configure(of: products[indexPath.row])
            return cell
        case SegmentedControlValue.grid.rawValue:
            break
        default:
            break
        }
        
        return UICollectionViewCell()
    }
}
