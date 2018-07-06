//
//  FilterTransactionManager.swift
//  mocs
//
//  Created by Rv on 22/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//
import UIKit

protocol FilterTransitionMangerDelegate {
    func dismiss()
}
class FilterTransactionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{

    let duration = 0.5
    var isPresenting = false
    
    var snapshot:UIView? {
        didSet {
            if let delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: Selector("dismiss"))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    var delegate:FilterTransitionMangerDelegate?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get reference to our fromView, toView and the container view
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // Set up the transform we'll use in the animation
//        guard let container = transitionContext.containerView() else {
//            return
//        }

        let container = transitionContext.containerView
        
        let moveDown = CGAffineTransform(translationX: 0, y: container.frame.height - 150)
        let moveUp = CGAffineTransform(translationX: 0, y: -50)
        
        // Add both views to the container view
        if isPresenting {
            toView.transform = moveUp
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        // Perform the animation
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresenting {
                self.snapshot?.transform = moveDown
                toView.transform = .identity
            } else {
                self.snapshot?.transform = .identity
                fromView.transform = moveUp
            }
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
            
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
}
