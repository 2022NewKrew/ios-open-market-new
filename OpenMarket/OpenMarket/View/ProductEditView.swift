import UIKit

class ProductEditView: ProductEditableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageButton.isHidden = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Product) {
        productName.text = data.name
        productCurrency.selectedSegmentIndex = data.currency == "KRW" ? 0 : 1
        productPrice.text = String.init(data.price)
        productDiscountPrice.text = String.init(data.discountedPrice)
        productStock.text = String.init(data.stock)
        productDetail.text = data.description ?? ""
        if let images = data.images {
            for image in images {
                let imageView = UIImageView()
                imageView.setImage(image: image)
                imageContentView.addArrangedSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            }
        }
    }
}
