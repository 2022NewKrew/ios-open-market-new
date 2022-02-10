import UIKit

class ProductEditViewController: UIViewController, KeyboardSizeControllable {
    let innerView: ProductEditableView
    var onkeyboardConstraints: [NSLayoutConstraint] = []
    lazy var bottomConstraint = innerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
    init(data: Product) {
        innerView = ProductEditView()
        super.init(nibName: nil, bundle: nil)
        (innerView as? ProductEditView)?.setupData(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(innerView)
        innerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        innerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        innerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        bottomConstraint.isActive = true
        view.backgroundColor = .systemBackground
        navigationController?.title = "상품수정"
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
        (innerView as? ProductEditView)?.updateProduct()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func cancelAdding() {
        navigationController?.popViewController(animated: true)
    }
}
