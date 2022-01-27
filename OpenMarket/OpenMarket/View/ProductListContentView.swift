//
//  ProductListContentView.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

@available(iOS 14.0, *)
class ProductListContentView: UIView, UIContentView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var prodcutPriceLabel: UILabel!
    @IBOutlet weak var productThumbnailImageView: UIImageView!
    
    private var currentConfiguration: ProductContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ProductContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    
    init(configuration: ProductContentConfiguration) {
        super.init(frame: .zero)
        loadNib()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(ProductListContentView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    private func apply(configuration: ProductContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        
        productNameLabel.text = configuration.productName
        prodcutPriceLabel.text = "\(configuration.currency?.rawValue ?? "KRW"):\(configuration.price ?? 0)"
        guard let imageUrl = configuration.thumbnailImage else { return }
        productThumbnailImageView.imageFromServerURL(url: imageUrl)
    }
}

extension UIImageView {

 public func imageFromServerURL(url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}
