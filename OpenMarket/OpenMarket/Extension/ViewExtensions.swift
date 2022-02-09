import Foundation
import UIKit

extension UIView {
    func constraintsToFit(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func constraintsToFit(_ guide: UILayoutGuide) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
}
