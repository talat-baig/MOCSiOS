//
//  RootViewController.swift
//  mocs
//
//  Created by Admin on 2/20/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import AKSideMenu
class RootViewController: AKSideMenu, AKSideMenuDelegate {

    var isFromLogin = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 5, height: 5)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.panFromEdge = false
        self.panGestureLeftEnabled = false
        
        if isFromLogin {
            self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController")
        } else {
            self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "contentViewController")
        }
        
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "leftMenuViewController")
        self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "rightMenuViewController")
        
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
    }

}
