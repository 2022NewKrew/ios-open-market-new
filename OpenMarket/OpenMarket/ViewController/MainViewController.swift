//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var products: [Product] = []
    private var collectionViewState: CollectionViewState = .list
    private var isLoading = false
    private var currentPage = 1
    private let itemsPerPage = 10
    
    private lazy var listFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 100)
        return layout
    }()
    
    private lazy var gridFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10 , left: 10, bottom: 10, right: 10)
        let cellWidth: CGFloat = view.bounds.width * 0.45
        let cellHeight: CGFloat = cellWidth * 1.4
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts(pageNo: currentPage, itemsPerPage: itemsPerPage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        products = []
        currentPage = 1
    }
    
    @IBAction func addAction(_ sender: Any) {
        guard let productEditViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ProductEditVC") as? ProductEditViewController else { return }
        productEditViewController.modalPresentationStyle = .fullScreen
        productEditViewController.mode = ProductEditViewController.AddMode(productEditViewController)
        present(productEditViewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionViewState = .list
            collectionView.reloadData()
            collectionView.setCollectionViewLayout(listFlowLayout, animated: false)
        case 1:
            collectionViewState = .grid
            collectionView.reloadData()
            collectionView.setCollectionViewLayout(gridFlowLayout, animated: false)
        default:
            break
        }
        
    }
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: Constant.listcellNib, bundle: .main),
                                forCellWithReuseIdentifier: Constant.listCellIdentifier)
        collectionView.register(UINib(nibName: Constant.gridCellNib, bundle: .main),
                                forCellWithReuseIdentifier: Constant.gridCellIdentifier)
        collectionView.collectionViewLayout = listFlowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchProducts(pageNo: Int, itemsPerPage: Int){
        isLoading = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        APIManager.shared.fetchProductList(pageNo: pageNo, itemsPerPage: itemsPerPage) { result in
            switch result {
            case .success(let page):
                self.products.append(contentsOf: page.pages)
                self.currentPage = page.pageNo + 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.isLoading = false
            }
        }
    }
    
    enum CollectionViewState {
        case list
        case grid
    }
    
    enum Constant {
        static let listcellNib = "ProductListCell"
        static let gridCellNib = "ProductGridCell"
        static let listCellIdentifier = "ListCell"
        static let gridCellIdentifier = "GridCell"
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionViewState {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.listCellIdentifier,
                                                          for: indexPath) as! ProductListCell
            cell.configureUI(product: products[indexPath.row])
            return cell
        case .grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.gridCellIdentifier,
                                                          for: indexPath) as! ProductGridCell
            cell.configureUI(product: products[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productEditViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ProductEditVC") as? ProductEditViewController else { return }
        productEditViewController.modalPresentationStyle = .fullScreen
        productEditViewController.mode = ProductEditViewController.EditMode(productEditViewController)
        productEditViewController.productId = products[indexPath.row].id
        present(productEditViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        if heightRemainBottomHeight < frameHeight {
            fetchProducts(pageNo: currentPage, itemsPerPage: itemsPerPage)
        }
    }
}
