//
//  AppDelegate.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        // Navigationbar Transparenz wird deaktiviert
        navigationBarAppearace.isTranslucent = false
        
        // entfernt den Schatten in der Navigationbar in allen Viewcontrollern
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.setBackgroundImage(UIImage(), for: .default)
        
        // Hintergrundfarbe der Navigationbar in allen Viewcontrollern
        navigationBarAppearace.tintColor = .black
        
        // Textfarbe des Titels in der Navigationbar in allen Viewcontrollern
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Anzeige des Viewcontrollers ohne ein Storyboard beim öffnen der App
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release sharedInstance resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Socket beendet die Verbindung wenn App minimiert wird
        Socket.sharedInstance.send(command: "quit#")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        // Socket beendet die Verbindung wenn App geschlossen wird
        Socket.sharedInstance.send(command: "quit#")
    }

    
}

// MARK: CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    
}


