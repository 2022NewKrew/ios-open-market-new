import UIKit

class SwipeImageView: UIStackView {
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let counter: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    
    var source: [Image] = []
    var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubviews([mainImageView, counter])
        self.axis = .vertical
        mainImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        counter.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        setGestures()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSourceData(source: [Image]) {
        self.source = source
        setInformation()
    }
    
    func setGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(repondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(repondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeft)
    }
    
    @objc
    func repondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if source.count == 0 {
            return
        }
        
        switch gesture.direction {
        case .left:
            index += (source.count - 1)
        
        case .right:
            index += 1
        
        default :
            return
        }
        index %= source.count
        setInformation()
    }
    
    func setInformation() {
        counter.text = "\(index + 1)/\(source.count)"
        mainImageView.setImage(image: source[index])
    }
}
