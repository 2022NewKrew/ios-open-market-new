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
    var products: [OpenMarketProduct?] = []
    
    enum SegmentedControlValue: Int {
        case list
        case grid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setup()
        self.fetchData(at: 0) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
    
    private func fetchData(at index: Int, completion: @escaping () -> Void) {
        let page = Int(ceil(Float(index + 1) / Float(Constants.itemsPerPage)))
        apiManager.getOpenMarketProductList(
            pageNumber: page,
            itemsPerPage: Constants.itemsPerPage
        ) { [weak self] result in
            let data = try? result.get()
            guard let products = data?.products,
                  let count = data?.totalCount else {
                return
            }
            if self?.products.count == 0 {
                self?.products = Array(repeating: nil, count: count)
            }
            
            products.enumerated().forEach { index, product in
                let index = (page - 1) * Constants.itemsPerPage + index
                self?.products[index] = product
            }
            completion()
        }
    }
    
    private func setupDelegate() {
        self.collectionView.dataSource = self
//        self.collectionView.prefetchDataSource = self
    }
    
    private func prefetchProductData(at indexPath: IndexPath) {
        self.fetchData(at: indexPath.row) {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: indexPath.row, section: 0)
                if self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
                    self.collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                }
            }
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.openMarketProductListCellReuseIdentifier,
                for: indexPath) as? OpenMarketProductListCell else {
                      return UICollectionViewCell()
                  }
            if let product = self.products[indexPath.row] {
                cell.configure(of: product)
                ImageLoader.loadImage(urlString: product.thumbnailURLString) { image in
                    if indexPath == collectionView.indexPath(for: cell) {
                        cell.thumbnailImageView.image = image
                    }
                }
                return cell
            }
            if (indexPath.row + 1) % Constants.itemsPerPage == 0 {
                self.prefetchProductData(at: indexPath)
            }
            return cell
        case SegmentedControlValue.grid.rawValue:
            break
        default:
            break
        }
        
        return UICollectionViewCell()
    }

}
