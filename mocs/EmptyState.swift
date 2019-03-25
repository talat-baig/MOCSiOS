//
//  EmptyState.swift
//  mocs
//
//  Created by Admin on 2/23/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import Foundation
import UIKit
class EmptyState:UIControl{
    /// The image view
    fileprivate(set) open var imageView: UIImageView!
    
    /// The text label
    fileprivate(set) open var textLabel: UILabel!
    
    /// The button
    fileprivate(set) open var button: UIButton!
    
    fileprivate(set) open var stackVw: UIStackView!

    
    /// The empty state image
    @IBInspectable
    open var image: UIImage{
        get{
            return imageView.image!
        }set{
            imageView.image = newValue
        }
    }
    
    /// The empty state message
    @IBInspectable
    open var message: String{
        get{
            return textLabel.text ?? ""
        }set{
            textLabel.text = newValue
        }
    }
    
    /// The button's text
    @IBInspectable
    open var buttonText: String{
        get{
            return button.title(for: [])!
        }set{
            button.setTitle(newValue, for: [])
        }
    }
    
    /// The button tint color
    @IBInspectable
    open var buttonTint: UIColor{
        get{
            return button.tintColor
        }set{
            button.layer.borderColor = newValue.cgColor
            button.tintColor = newValue
        }
    }
    
    /// Is the button visable
    @IBInspectable
    open var buttonHidden: Bool = false{
        didSet{
            button.isHidden = buttonHidden
        }
    }
    
    /// Convenience initailizer
    ///
    /// - Parameters:
    ///   - image: The image of the empty state
    ///   - message: The message of the empty sate
    ///   - buttonText: The text on the button, if nil then button will be hidden.
    convenience public init(image: UIImage ,message: String, buttonText: String? = nil){
        self.init(frame: CGRect.zero)
        self.image = image
        self.message = message
        if let buttonText = buttonText {
            self.buttonText = buttonText
        } else {
            buttonHidden = true
        }
    }
    
    
    /// Init with Frame
    ///
    /// - Parameter frame: frame for the view.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    /// When adding a target, it will be automatically added to the button.
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called. If you specify nil, UIKit searches the responder chain for an object that responds to the specified action message and delivers the message to that object.
    ///   - action: A selector identifying the action method to be called. You may specify a selector whose signature matches any of the signatures in UIControl. This parameter must not be nil.
    ///   - controlEvents: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant. For a list of possible constants, see UIControlEvents.
    final override public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    /// A function that is called when it's time to setup the label.
    ///
    /// - Returns: The label view.
    open func setupLabel()->UILabel{
        let textLabel = UILabel()
        //        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        textLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            textLabel.font = UIFont.systemFont(ofSize: 20.0)
        } else {
            textLabel.font = UIFont.systemFont(ofSize: 14.0)
        }
        
        return textLabel
    }
    
    
    /// A function that is called when it's time to setup the image view.
    ///
    /// - Returns: The image view.
    open func setupImage()->UIImageView{
        return UIImageView()
    }
    
    
    /// A function that is called when it's time to setup the button.
    ///
    /// - Returns: The button.
    open func setupButton()->UIButton{
        let button = UIButton(type: .system)

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
             button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return button
    }
    
    open func setupView()->UIView{
        return UIView()
    }
    
    
    /// A function that is called when it's time to setup the stack of the empty state which contains all the views.
    ///
    /// - Parameters:
    ///   - imageView: The image view of the empty state.
    ///   - textLabel: The label of the empty state.
    ///   - button: The button of the empty state.
    /// - Returns: The stack view.
    open func setupStack( _ tempVw: UIView,_ imageView: UIStackView,_ textLabel: UILabel,_ button: UIButton, _ textLabel1: UILabel)->UIStackView{
        let stackView = UIStackView(arrangedSubviews: [tempVw, imageView,textLabel,button,textLabel1])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }
    
    open func setupHorStack(_ imageView: UIImageView,_ imageView1: UIImageView,_ imageView2: UIImageView)->UIStackView{
        let stackView = UIStackView(arrangedSubviews: [imageView,imageView1,imageView2])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }
    
    
    /// The setup function is called from the initializers
    private func setup(){
        backgroundColor = .clear
        
        // Setup views
        let imageView1 = setupImage()
        imageView = setupImage()
        let imageView2 = setupImage()

        textLabel = setupLabel()
        button = setupButton()
        let tempVw = setupView()

        stackVw = setupHorStack(imageView1, imageView, imageView2)
//        let tempLabel1 = setupLabel()
        let tempLabel2 = setupLabel()

        let stackView = setupStack(tempVw,stackVw,textLabel,button,tempLabel2)
        
        // make imageView square
        imageView.translatesAutoresizingMaskIntoConstraints = false
        tempVw.heightAnchor.constraint(equalToConstant: 20).isActive = true

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        }  else {
            imageView1.widthAnchor.constraint(equalToConstant: 53).isActive = true
            imageView2.widthAnchor.constraint(equalToConstant: 53).isActive = true

//            tempVw.backgroundColor = UIColor.cyan
            imageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            textLabel.frame.size.height = textLabel.intrinsicContentSize.height
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        // add constraints to stackview
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
    }
}
