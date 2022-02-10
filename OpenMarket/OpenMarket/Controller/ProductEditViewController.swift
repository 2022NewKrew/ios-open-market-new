import UIKit

class ProductEditViewController: UIViewController {
    let editView: ProductEditView
    var onkeyboardConstraints: [NSLayoutConstraint] = []
    lazy var bottomConstraint = editView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
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
        editView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        editView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
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
//        editView.saveProduct()
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
            onkeyboardConstraints = [editView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)]
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
