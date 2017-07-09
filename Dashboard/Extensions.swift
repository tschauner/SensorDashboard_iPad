//
//  Extensions
//  Dashboard
//
//  Created by Philipp Tschauner on 18.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


// alert

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
    
    // allert sheet

}

