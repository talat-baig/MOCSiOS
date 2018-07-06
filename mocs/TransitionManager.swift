//
//  TransitionManager.swift
//  mocs
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit

protocol TransitionDelegate {
    func dismiss()
}

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.5
    var isPresenting = false
    var delegate: TransitionDelegate?
    
    var snapshot:UIView? {
        didSet {
            if let delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: Selector(("dismiss")))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)
        let moveUp = CGAffineTransform(translationX: 0, y: -50)
        
        if isPresenting{
            toView?.transform = moveUp
            snapshot = fromView?.snapshotView(afterScreenUpdates: true)
            container.addSubview((toView)!)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView!.transform = .identity
            } else {
                self.snapshot?.transform = .identity
                fromView!.transform = moveUp
            }
            
        }, completion: { finished in
            transitionContext.completeTransition(true)
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}
