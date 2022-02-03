//
//  OpenMarket - ProductListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var loadingUI: UIActivityIndicatorView!
    @IBOutlet weak var productSegmentedControll: UISegmentedControl!

    private let productListViewModel = ProductListViewModel()
    private var productList: ProductList?
    private var segmentedControlIndex: Int {
        self.productSegmentedControll.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewModel()
        self.productListViewModel.productList(pageNumber: 1, itemPerPage: 20)
        DispatchQueue.main.async {
            self.loadingUI.startAnimating()
            self.loadingUI.isHidden = false
        }
    }

    @IBAction func pressAddProductButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Constant.productSegue, sender: self)
    }

    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.productListCollectionView.collectionViewLayout = self.createListCompositionLayout()
            self.productListCollectionView.reloadData()
        case 1:
            self.productListCollectionView.collectionViewLayout = self.createGridCompositionLayout()
            self.productListCollectionView.reloadData()
        default:
            break
        }
    }

    private func setViewModel() {
        self.productListViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.productList = self.productListViewModel.productList
            self.setCollectionView()
            DispatchQueue.main.async {
                self.loadingUI.stopAnimating()
                self.loadingUI.isHidden = true
            }
        }
    }

    private func setCollectionView() {
        DispatchQueue.main.async {
            self.productListCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ListCollectionViewCell.self))
            self.productListCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
            self.productListCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.productListCollectionView.collectionViewLayout = self.createListCompositionLayout()
            self.productListCollectionView.delegate = self
            self.productListCollectionView.dataSource = self
        }
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

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.12))
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

}

// MARK - DataSource
extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productList?.itemsPerPage ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var productCell: ProductCell
        if self.segmentedControlIndex == 0 {
            let cellIdentifier = String(describing: ListCollectionViewCell.self)
            guard let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListCollectionViewCell else {
                return UICollectionViewCell()
            }
            productCell = cell
        } else {
            let cellIdentifier = String(describing: GridCollectionViewCell.self)
            guard let cell = productListCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GridCollectionViewCell else {
                return UICollectionViewCell()
            }
            productCell = cell
        }

        guard let product = productList?.products?[indexPath.row] else {
            return productCell
        }

        productCell.updateCell(product: product)

        return productCell
    }
}
