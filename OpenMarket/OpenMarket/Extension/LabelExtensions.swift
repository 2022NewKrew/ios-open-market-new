import Foundation
import UIKit

extension UILabel {
    func markDiscountPrice(target: String) {
        let fullText = self.text ?? ""
        let targetRange = (fullText as NSString).range(of: target)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: targetRange)
        attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.systemRed, range: targetRange)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: targetRange)
        self.attributedText = attributedString
    }
}
