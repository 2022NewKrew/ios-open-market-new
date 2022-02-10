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
    private var recentlySelectedIndex: Int?
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProductDetailViewController,
              let index = self.recentlySelectedIndex else {
                  return
              }
        destination.product = self.products[index]
    }
    
    private func setup() {
        self.registerViews()
        self.setupDelegate()
        self.addTargets()
    }
    
    private func registerViews() {
        let listCellNibFile = UINib(nibName: ListConstants.openMarketProcutListCellNibFileName, bundle: nil)
        self.collectionView.register(listCellNibFile, forCellWithReuseIdentifier: ListConstants.openMarketProductListCellReuseIdentifier)
        
        let gridCellNibFile = UINib(nibName: ListConstants.openMarketProductGridCellNibFileName, bundle: nil)
        self.collectionView.register(gridCellNibFile, forCellWithReuseIdentifier: ListConstants.openMarketProductGridCellReuseIdentifier)
        
        let loadingReusableView = UINib(nibName: ListConstants.openMarketProcutFooterViewFileName, bundle: nil)
        self.collectionView.register(loadingReusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ListConstants.openMarketProductFooterViewIdentifier)
    }
    
    private func fetchData(at index: Int, completion: @escaping () -> Void) {
        let page = Int(ceil(Float(index + 1) / Float(ListConstants.itemsPerPage)))
        apiManager.getOpenMarketProductList(
            pageNumber: page,
            itemsPerPage: ListConstants.itemsPerPage
        ) { [weak self] result in
            let data = try? result.get()
            guard let products = data?.products,
                  let totalCount = data?.totalCount else {
                      return
                  }
            self?.totalCount = totalCount
            self?.products.append(contentsOf: products)
            products.enumerated().forEach { index, product in
                let index = (page - 1) * ListConstants.itemsPerPage + index
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

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var currentCell: OpenMarketProductCellType?
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListConstants.openMarketProductListCellReuseIdentifier,
                for: indexPath) as? OpenMarketProductListCell else {
                    return UICollectionViewCell()
                }
            currentCell = cell
        case SegmentedControlValue.grid.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListConstants.openMarketProductGridCellReuseIdentifier,
                for: indexPath) as? OpenMarketProductGirdCell else {
                    return UICollectionViewCell()
                }
            currentCell = cell
        default:
            break
        }
        
        guard let currentCell = currentCell else {
            return UICollectionViewCell()
        }
        
        if let product = self.products[indexPath.row] {
            currentCell.configure(of: product)
            ImageLoader.loadImage(urlString: product.thumbnailURLString) { image in
                if indexPath == collectionView.indexPath(for: currentCell) {
                    currentCell.thumbnailImageView.image = image
                }
            }
        }
        return currentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListConstants.openMarketProductFooterViewIdentifier, for: indexPath) as? LoadingFooterView else{
                  return UICollectionReusableView()
                  
              }
        loadingFooterView.backgroundColor = .clear
        self.loadingView = loadingFooterView
        return loadingFooterView
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.recentlySelectedIndex = indexPath.row
        guard var product = self.products[indexPath.row],
              let productId = product.id else {
                  return
              }
        self.apiManager.getOpenMarketProductDetail(
            productId: productId
        ) { result in
            guard let detailInfo = try? result.get() else {
                return
            }
            product.setDetailInfo(
                description: detailInfo.description,
                images: detailInfo.images,
                vendor: detailInfo.vendor
            )
            self.products[indexPath.row] = product
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: DetailConstnts.detailSegueIdentifier, sender: nil)
            }
        }
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
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: self.collectionView.bounds.size.width, height: ListConstants.loadingFooterViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.grid.rawValue:
            return ListConstants.openMarketProductGridCellMinimumInterLineSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch layoutSegmentedControl.selectedSegmentIndex {
        case SegmentedControlValue.grid.rawValue:
            return ListConstants.openMarketProductGridCellMinimumInterItemSpacing
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: ListConstants.openMarketPrdouctCellTopBottomInset,
            left: ListConstants.openMarketPrdouctCellLeadingTrailingInset,
            bottom: ListConstants.openMarketPrdouctCellTopBottomInset,
            right: ListConstants.openMarketPrdouctCellLeadingTrailingInset
        )
    }
}
