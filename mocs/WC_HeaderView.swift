
import UIKit

protocol WC_HeaderViewDelegate {
    
    func backBtnTapped(sender: Any)
    func topMenuLeftButtonTapped(sender: Any)
    func topMenuRightButtonTapped(sender: Any)
}

@IBDesignable

/// Top view
class WC_HeaderView: UIView {
    
    /// UIView
    @IBOutlet var view: CardView!
    
    /// Delegate
    var delegate: WC_HeaderViewDelegate?
    
    /// Back button
    @IBOutlet weak var btnBack: UIButton!
    
    /// Button left
    @IBOutlet weak var btnLeft: UIButton!
    
    /// Button right
    @IBOutlet weak var btnRight: UIButton!
    
    /// Label for title
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Label for subtitle
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: WC_HeaderView.self)).instantiate(withOwner: self, options: nil)
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY , metrics: nil, views: ["view": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX , metrics: nil, views: ["view": view]))
        
    }
    
    /// Top view left button tap event action
    @IBAction func btnLeftTouchUpInside(_ sender: Any) {
        if let d = delegate {
            d.topMenuLeftButtonTapped(sender: sender)
        }
    }
    
    /// Top left back button tap event action 
    @IBAction func btnBackTouchUpInside(_ sender: Any) {
        if let d = delegate {
            d.backBtnTapped(sender: sender)
        }
    }
    
    
    /// Top view right button tap event action
    @IBAction func btnRightTouchUpInside(_ sender: Any) {
        if let d = delegate {
            d.topMenuRightButtonTapped(sender: sender)
        }
    }
}
