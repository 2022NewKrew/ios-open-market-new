import UIKit

class ProductDetailViewController: UIViewController {
    let detailView = ProductDetailView()
    let data: Product
    
    init(data: Product) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        detailView.configureData(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(editOrDelete))
        navigationController?.title = data.name
    }
    
    @objc
    func editOrDelete() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "edit", style: .default, handler: editAction(_:))
        let delete = UIAlertAction(title: "delete", style: .destructive, handler: deleteAction(_:))
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc
    func editAction(_ action: UIAlertAction) {
        let editViewController = ProductEditViewController(data: self.data)
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @objc
    func deleteAction(_ action: UIAlertAction) {
        let deleteAlert = UIAlertController(title: "암호", message: "상품 암호를 입력해주세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: { action in
            OpenMarketAPI.shared.deleteProduct(productId: self.data.id, secret: deleteAlert.textFields?[0].text ?? "")
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        deleteAlert.addTextField(configurationHandler: nil)
        deleteAlert.addAction(ok)
        deleteAlert.addAction(cancel)
        self.present(deleteAlert, animated: true, completion: nil)
    }
}
