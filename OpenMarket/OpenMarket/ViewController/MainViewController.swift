//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var products: [Product] = []
    private var collectionViewState: CollectionViewState = .list
    private var isLoading = false
    
    private lazy var listFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 70)
        return layout
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
        // API Test
        APIManager.shared.fetchProductList(pageNo: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let page):
                self.products.append(contentsOf: page.pages)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionViewState = .list
        case 1:
            collectionViewState = .grid
        default:
            break
        }
        
    }
    
    func configureCollectionView(){
        collectionView.register(UINib(nibName: "ProductListCell", bundle: .main), forCellWithReuseIdentifier: "ListCell")
        collectionView.collectionViewLayout = listFlowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    

    enum Section {
        case main
    }
    
    enum CollectionViewState {
        case list
        case grid
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionViewState {
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ProductListCell
            cell.configureUI(product: products[indexPath.row])
            
            return cell
        case .grid:
            //cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ProductGridCell
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    
}
