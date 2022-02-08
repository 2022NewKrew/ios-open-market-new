import UIKit

class ProductEditViewController: UIViewController {
    let editView = ProductEditView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editView)
        editView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        editView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        editView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        editView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        view.backgroundColor = .systemBackground
        navigationController?.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
    }
}

extension ProductEditViewController: UIImagePickerControllerDelegate {
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
            editView.addImage(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProductEditViewController: UINavigationControllerDelegate {
    
}
