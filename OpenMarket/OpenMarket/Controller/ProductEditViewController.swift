import UIKit

class ProductEditViewController: UIViewController {
    let editView: ProductEditView
    
    init(data: Product) {
        editView = ProductEditView()
        super.init(nibName: nil, bundle: nil)
        editView.setupData(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editView)
        editView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        editView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        editView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        editView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        view.backgroundColor = .systemBackground
        navigationController?.title = "상품등록"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAdding))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addProduct))
    }
    
    @objc
    func addProduct() {
//        editView.saveProduct()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelAdding() {
        navigationController?.popViewController(animated: true)
    }
}
