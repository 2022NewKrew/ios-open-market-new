//
//  ProductRegisterationViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import UIKit

class ProductRegisterationViewController: UIViewController {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    
    private let apiManager = OpenMarketAPIManager()
    private let picker = UIImagePickerController()
    private let maxImageCount = 5
    private var currentImageCount = 0
    private lazy var imageViews: [UIImageView] = {
        return [
            self.firstImageView,
            self.secondImageView,
            self.thirdImageView,
            self.fourthImageView,
            self.fifthImageView
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImagePickerViewController()
    }
    
    private func configureImagePickerViewController() {
        self.picker.sourceType = .photoLibrary
        self.picker.delegate = self
        self.picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)?.filter({ $0.contains("image") }) {
            self.picker.mediaTypes = mediaTypes
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum),
                  let mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)?.filter({ $0.contains("image") }) {
            self.picker.mediaTypes = mediaTypes
        }
    }
    
    @IBAction func pickImage(_ sender: Any) {
        self.present(self.picker, animated: true, completion: nil)
    }
    @IBAction func postImage(_ sender: Any) {
        apiManager.postOpenMarketProduct(
            identifier: APIConstants.vendorIdentifier,
            params: OpenMarketProductPostParam(
                name: "꽃",
                descriptions: "꽃꽃",
                price: 1000,
                currency: .krw,
                discountedPrice: 100,
                stock: 10,
                secret: APIConstants.vendorPassword
            ),
            images: imageViews
                .filter{ $0.image != nil
                }.map{ $0.image! }
        ) { result in
            print(result)
        }
    }
}

extension ProductRegisterationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.picker.dismiss(animated: true)
            return
        }
        
        if self.currentImageCount < self.maxImageCount {
            self.imageViews[currentImageCount].image = image
            self.imageViews[currentImageCount].isHidden = false
            currentImageCount += 1
        }
        
        self.picker.dismiss(animated: true)
    }
}
