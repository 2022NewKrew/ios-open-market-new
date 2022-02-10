import UIKit

class ProductAddView: ProductEditableView {
    func addImage(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageContentView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        if let data = image.pngData() {
            let scale = Double.init(data.count / (1048576/5))
            if scale > 1 {
                if let newImage = image.resizeImage(scale: scale),
                    let data = newImage.pngData() {
                    imageView.image = newImage
                    imageData.append(data)
                    return
                }
            }
            imageData.append(data)
        }
    }

    func saveProduct() {
        var data: [String: String] = [:]
        data["name"] = productName.text
        data["descriptions"] = productDetail.text
        data["price"] = productPrice.text
        data["currency"] = productCurrency.selectedSegmentIndex == 0 ? "KRW" : "USD"
        data["discounted_price"] = productDiscountPrice.text
        data["stock"] = productStock.text
        OpenMarketAPI.shared.addProduct(data: &data, images: &imageData)
    }
}
