//
//  OpenMarket - ProductListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var initLoadingUI: UIActivityIndicatorView!
    @IBOutlet weak var pagingLoadingUI: UIActivityIndicatorView!
    @IBOutlet weak var productSegmentedControl: UISegmentedControl!

    private let productListViewModel = ProductListViewModel()
    private var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewModel()
        self.productListViewModel.productList()
        DispatchQueue.main.async {
            self.initLoadingUI.startAnimating()
        }
    }

    @IBAction func pressAddProductButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Constant.productSegue, sender: self)
    }

    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case ProductListSegmentValue.list.rawValue:
            self.productListCollectionView.collectionViewLayout = self.createListCompositionLayout()
            self.productListCollectionView.reloadData()
        case ProductListSegmentValue.grid.rawValue:
            self.productListCollectionView.collectionViewLayout = self.createGridCompositionLayout()
            self.productListCollectionView.reloadData()
        default:
            break
        }
    }

    private func setViewModel() {
        self.productListViewModel.updateView = { [weak self] pageNumber in
            guard let self = self else { return }

            self.products = self.productListViewModel.products
            DispatchQueue.main.async {
                self.setCollectionView()
                switch pageNumber {
                case 1:
                    self.initLoadingUI.stopAnimating()
                default:
                    self.pagingLoadingUI.stopAnimating()
                }
                self.productListViewModel.isPaginating = false
            }
        }
    }

    private func setCollectionView() {
        self.productListCollectionView.delegate = self
        self.productListCollectionView.dataSource = self
        self.productListCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ListCollectionViewCell.self))
        self.productListCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        self.productListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.productListCollectionView.collectionViewLayout = self.createListCompositionLayout()
    }
}

// MARK - UICollectionViewLayout
extension ProductListViewController {
    private func createListCompositionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }

    private func createGridCompositionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

// MARK - Delegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constant.productSegue, sender: self)
    }
}

// MARK - DataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var productCell: ProductCell

        if self.productSegmentedControl.selectedSegmentIndex == ProductListSegmentValue.list.rawValue {
            let cellIdentifier = String(describing: ListCollectionViewCell.self)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListCollectionViewCell else {
                return UICollectionViewCell()
            }

            productCell = cell
        } else {
            let cellIdentifier = String(describing: GridCollectionViewCell.self)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GridCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            productCell = cell
        }

        guard let products = self.products,
              indexPath.row < products.count
        else {
            return productCell
        }

        let product = products[indexPath.row]
        productCell.updateCell(product: product, indexPath: indexPath, collectionView: collectionView)

        return productCell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let frameHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = contentHeight - contentYOffset

        if distanceFromBottom < frameHeight {
            guard self.productListViewModel.isPaginating == false else { return }

            self.productListViewModel.productList()
            DispatchQueue.main.async {
                self.pagingLoadingUI.startAnimating()
            }
        }
    }
}
