//
//  AppDelegate.swift
//  mocs
//
//  Created by Rv on 21/01/18.
//  Copyright © 2018 Rv. All rights reserved.
//

import UIKit
import Firebase
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        MocsDB.setUpDatabase()
        UINavigationBar.appearance().barTintColor = AppColor.universalHeaderColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        self.setupSiren()
        
        if Session.login {
            
            let storyBoard: UIStoryboard = UIStoryboard(name:"Home",bundle:nil)
            let mainPage = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
            Helper.setUserDefault(forkey: "isAfterLogin", valueBool: false)
            self.window?.rootViewController = mainPage
        } else {
            
            let storyBoard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let loginPg = storyBoard.instantiateViewController(withIdentifier: "loginController") as! ViewController
            self.window?.rootViewController = loginPg
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func setupSiren() {
    
        /* Siren code should go below window?.makeKeyAndVisible() */
        
        // Siren is a singleton
        let siren = Siren.shared
        
        // Optional: Defaults to .option
        siren.alertType = Siren.AlertType.force
        
        // Optional: Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
        siren.alertMessaging = SirenAlertMessaging(updateTitle: "Update Available",
                                                   updateMessage: "A new version of mOCS is available. Please update to the latest version now.",
                                                   updateButtonMessage: "Update")
        
        // Optional: Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
//        siren.debugEnabled = true
        // Replace .immediately with .daily or .weekly to specify a maximum daily or weekly frequency for version checks.
        // DO NOT CALL THIS METHOD IN didFinishLaunchingWithOptions IF YOU ALSO PLAN TO CALL IT IN applicationDidBecomeActive.
        siren.checkVersion(checkType: .immediately)

    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }


}

