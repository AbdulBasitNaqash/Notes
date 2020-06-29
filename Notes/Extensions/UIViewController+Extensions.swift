//
//  UIViewController+Extensions.swift
//  Notes
//
//  Created by Abdul Basit on 04/06/20.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Alerts
    func showAlert(with title: String, and message: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
}
