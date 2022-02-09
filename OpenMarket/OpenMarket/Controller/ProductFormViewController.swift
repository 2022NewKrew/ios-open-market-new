import UIKit

class ProductFormViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate {
    private var product: ProductDetail?
    private let scrollView = UIScrollView()
    private let container = UIView()
    private let productAddingForm = ProductFormView()
    private let imagePickerController = UIImagePickerController()
    private var addedImages: [UIImage] = []
    private var numOfCell = 1
    var delegate: ViewController?
    
    private lazy var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width*0.35), collectionViewLayout: flowLayout)
        return collectionView
    }()

    init(prod: ProductDetail?) {
        product = prod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationItems()
        setUI()
        if product != nil {
            navigationItem.title = "상품수정"
            setProductData()
        }
    }
    
    func setProductData() {
        productAddingForm.setData(with: product!)
    }
    
    @objc
    private func endEditing() {
        view.endEditing(true)
    }
    
    func viewTapGuesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setUI() {
        viewTapGuesture()

        view.addSubview(scrollView)
        arrangeConstraint(view: scrollView, guide: view.safeAreaLayoutGuide)
        scrollView.addSubview(container)
        arrangeConstraint(view: container, guide: scrollView.contentLayoutGuide)
        container.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        setImageCollectionView()
        setFormView()
    }
    
    func setImageCollectionView() {
        container.addSubview(imageCollectionView)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: container.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            imageCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            imageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width*0.35)
        ])
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    func setFormView() {
        container.addSubview(productAddingForm)
        productAddingForm.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productAddingForm.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            productAddingForm.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            productAddingForm.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            productAddingForm.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        ])
    }
    
    func setNavigationItems() {
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
    }
    
    @objc
    func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func doneAction() {
        let formData = productAddingForm.getFormData()
        let networkConnector = NetworkConnector()
        guard let prod = product else {
            networkConnector.requestPost(productData: formData, productImages: addedImages) {
                result in
                switch result {
                case .success(let data):
                    self.delegate?.resetDataSource()
                case .failure(let error):
                    print(error.description)
                }
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
        networkConnector.requestPATCH(path: "api/products/\(prod.id)", productData: formData) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.resetDataSource()
            case .failure(let error):
                print(error.description)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func arrangeConstraint(view: UIView, guide: UILayoutGuide) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
}

extension ProductFormViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let prod = product else {
            return numOfCell
        }
        return prod.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        guard let prod = product else {
            if addedImages.count != 0 && indexPath.row < addedImages.count {
                cell.setImage(addedImage: addedImages[indexPath.row])
            } else if addedImages.count < 5 {
                cell.setPlusImage()
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
                cell.imageView.addGestureRecognizer(tapGesture)
                cell.imageView.isUserInteractionEnabled = true
            }
            return cell
        }
        cell.setImage(imageURLString: prod.images[indexPath.row].url)
        return cell
    }
    
    @objc
    func touchToPickPhoto() {
        if addedImages.count == 5 {
            return
        }
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProductFormViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        addedImages.append(selectedImage)
        picker.dismiss(animated: true, completion: nil)
        numOfCell += numOfCell <= 4 ? 1 : 0
        imageCollectionView.reloadData()
    }
}

extension ProductFormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width*0.3, height: view.frame.width*0.3)
    }
}
