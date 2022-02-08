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
    
    private let apiManager = OpenMarketAPIManager()
    private var products: [OpenMarketProduct?] = []
    private var isLoading = false
    private var loadingView: LoadingFooterView?
    private var totalCount: Int = 0
    
    enum SegmentedControlValue: Int {
        case list
        case grid
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.products = []
        self.fetchData(at: 0) {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    private func setup() {
        self.registerViews()
        self.setupDelegate()
        self.addTargets()
    }
    
    private func registerViews() {
        let listCellNibFile = UINib(nibName: Constants.openMarketProcutListCellNibFileName, bundle: nil)
        self.collectionView.register(listCellNibFile, forCellWithReuseIdentifier: Constants.openMarketProductListCellReuseIdentifier)
        
        let gridCellNibFile = UINib(nibName: Constants.openMarketProductGridCellNibFileName, bundle: nil)
        self.collectionView.register(gridCellNibFile, forCellWithReuseIdentifier: Constants.openMarketProductGridCellReuseIdentifier)
        
        let loadingReusableView = UINib(nibName: Constants.openMarketProcutFooterViewFileName, bundle: nil)
        self.collectionView.register(loadingReusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.openMarketProductFooterViewIdentifier)
    }
    
    private func fetchData(at index: Int, completion: @escaping () -> Void) {
        let page = Int(ceil(Float(index + 1) / Float(Constants.itemsPerPage)))
        apiManager.getOpenMarketProductList(
            pageNumber: page,
            itemsPerPage: Constants.itemsPerPage
        ) { [weak self] result in
            let data = try? result.get()
            guard let products = data?.products,
                  let totalCount = data?.totalCount else {
                      return
                  }
            self?.totalCount = totalCount
            self?.products.append(contentsOf: products)
            products.enumerated().forEach { index, product in
                let index = (page - 1) * Constants.itemsPerPage + index
                self?.products[index] = product
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func setupDelegate() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func addTargets() {
        self.layoutSegmentedControl.addTarget(
            self,
            action: #selector(segmentedControlValueDidChange),
            for: .valueChanged
        )
    }
    
    @objc func segmentedControlValueDidChange(_ segmentedControl: UISegmentedControl) {
        self.collectionView.reloadData()
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            }
            return cell
            
        case SegmentedControlValue.grid.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.openMarketProductGridCellReuseIdentifier,
                for: indexPath) as? OpenMarketProductGirdCell else {
                    return UICollectionViewCell()
                }
            if let product = self.products[indexPath.row] {
                cell.configure(of: product)
                ImageLoader.loadImage(urlString: product.thumbnailURLString) { image in
                    if indexPath == collectionView.indexPath(for: cell) {
                        cell.thumbnailImageView.image = image
                    }
                }
            }
            return cell
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.products.count == self.totalCount {
            return
        }
        if indexPath.row == self.products.count - 10 && !self.isLoading {
            self.isLoading = true
            self.fetchData(at: indexPath.row + 10) {
                self.collectionView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaWidth = self.view.safeAreaLayoutGuide.layoutFrame.width
        
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.list.rawValue:
            let width = OpenMarketProductListCell.cellForWidth(safeAreaWidth: safeAreaWidth)
            let height = OpenMarketProductListCell.cellForHeight(safeAreaWidth: safeAreaWidth)
            return CGSize(width: width, height: height)
        case SegmentedControlValue.grid.rawValue:
            let width = OpenMarketProductGirdCell.cellForWidth(safeAreaWidth: safeAreaWidth)
            let height = OpenMarketProductGirdCell.cellForHeight(safeAreaWidth: safeAreaWidth)
            return CGSize(width: width, height: height)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading || self.products.count == self.totalCount {
            return .zero
        }
        return CGSize(width: self.collectionView.bounds.size.width, height: Constants.loadingFooterViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.openMarketProductFooterViewIdentifier, for: indexPath) as? LoadingFooterView else{
                  return UICollectionReusableView()
                  
              }
        loadingFooterView.backgroundColor = .clear
        self.loadingView = loadingFooterView
        return loadingFooterView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter && self.isLoading {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.grid.rawValue:
            return Constants.openMarketProductGridCellMinimumInterItemSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.grid.rawValue:
            return Constants.openMarketProductGridCellMinimumInterLineSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(
                top: Constants.openMarketPrdouctCellTopBottomInset,
                left: Constants.openMarketPrdouctCellLeadingTrailingInset,
                bottom: Constants.openMarketPrdouctCellTopBottomInset,
                right: Constants.openMarketPrdouctCellLeadingTrailingInset
            )
    }
}
