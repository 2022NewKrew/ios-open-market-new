import UIKit

class ProductAddViewController: UIViewController, KeyboardSizeControllable {
    let innerView: ProductEditableView = ProductAddView()
    var onkeyboardConstraints: [NSLayoutConstraint] = []
    lazy var bottomConstraint = innerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(innerView)
        innerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        innerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        innerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        bottomConstraint.isActive = true
        view.backgroundColor = .systemBackground
        navigationController?.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAdding))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addProduct))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    @objc
    func addProduct() {
        (innerView as? ProductAddView)?.saveProduct()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelAdding() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductAddViewController: UIImagePickerControllerDelegate {
    @objc
    func presentAlbum(){
        if innerView.imageData.count >= 5 {
            let okay = UIAlertAction(title: "확인", style: .default, handler: nil)
            let alertController = UIAlertController(title: "오류", message: "이미지는 5개까지만 가능해요", preferredStyle: .alert)
            alertController.addAction(okay)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            (innerView as? ProductAddView)?.addImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProductAddViewController: UINavigationControllerDelegate {
    
}
