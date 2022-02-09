import UIKit

class ProductAddViewController: UIViewController {
    let addView = ProductAddView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addView)
        addView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        addView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        view.backgroundColor = .systemBackground
        navigationController?.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAdding))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addProduct))
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
}

extension ProductAddViewController: UIImagePickerControllerDelegate {
    @objc
    func presentAlbum(){
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
