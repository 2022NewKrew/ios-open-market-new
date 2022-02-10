import UIKit

class ProductAddViewController: UIViewController {
    let addView = ProductAddView()
    var onkeyboardConstraints: [NSLayoutConstraint] = []
    lazy var bottomConstraint = addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addView)
        addView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        addView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        addView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
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
        addView.saveProduct()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelAdding() {
        navigationController?.popViewController(animated: true)
    }
    
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc
    func keyboardWillShow(_ notification: NSNotification){
        if onkeyboardConstraints.count == 0, let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            onkeyboardConstraints = [addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)]
        }
        NSLayoutConstraint.deactivate([bottomConstraint])
        NSLayoutConstraint.activate(onkeyboardConstraints)
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification){
        NSLayoutConstraint.deactivate(onkeyboardConstraints)
        NSLayoutConstraint.activate([bottomConstraint])
    }
}

extension ProductAddViewController: UIImagePickerControllerDelegate {
    @objc
    func presentAlbum(){
        if addView.imageData.count >= 5 {
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
            addView.addImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProductAddViewController: UINavigationControllerDelegate {
    
}
