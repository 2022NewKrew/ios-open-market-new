//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell,Product> { cell,indexPath,item in
            cell.product = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
               (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                       for: indexPath,
                                                                       item: identifier)
            cell.accessories = [.disclosureIndicator()]
               return cell
        }
        
        snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        
        // API Test
        APIManager.shared.fetchProductList(pageNo: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let page):
                self.snapshot.appendItems(page.pages, toSection: .main)
                self.dataSource.apply(self.snapshot, animatingDifferences: false)
            case .failure(let error):
                print(error)
            }
        }
    }


    enum Section {
        case main
    }
}

