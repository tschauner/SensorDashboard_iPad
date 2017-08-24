//
//  Extensions
//  Dashboard
//
//  Created by Philipp Tschauner on 18.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


// Funktion Extension für die Benutzung von Alarmen
extension UIViewController {
    
    func showAlert(title: String, contentText: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: contentText, preferredStyle: .alert)
            for action in actions {
                alertController.addAction(action)
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

// Funktion Extension für die Benutzung von Userdefaults
extension UserDefaults {
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

