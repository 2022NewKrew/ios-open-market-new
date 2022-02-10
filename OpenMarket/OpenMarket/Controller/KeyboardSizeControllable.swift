import Foundation
import UIKit

protocol KeyboardSizeControllable: UIViewController {
    var onkeyboardConstraints: [NSLayoutConstraint] {get set}
    var bottomConstraint: NSLayoutConstraint {get}
    var innerView: ProductEditableView {get}
    
    func addKeyboardNotifications()
    func removeKeyboardNotifications()
    func keyboardWillShow(_ notification: NSNotification)
    func keyboardWillHide(_ notification: NSNotification)
}

extension KeyboardSizeControllable {
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification as NSNotification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification as NSNotification)
        }
    }

    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(_ notification: NSNotification){
        if onkeyboardConstraints.count == 0, let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            onkeyboardConstraints = [innerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardHeight)]
        }
        NSLayoutConstraint.deactivate([bottomConstraint])
        NSLayoutConstraint.activate(onkeyboardConstraints)
    }

    func keyboardWillHide(_ notification: NSNotification){
        NSLayoutConstraint.deactivate(onkeyboardConstraints)
        NSLayoutConstraint.activate([bottomConstraint])
    }
}
