//
//  ViewControllerExtension.swift
//  mealReference
//
//  Created by Matt Goodhart on 1/7/22.
//

import UIKit


extension UIViewController {
    
    func handleButton(button: UIButton, isEnabled: Bool) {
        if isEnabled {
            DispatchQueue.main.async {
                button.isEnabled = true
                button.alpha = 1.0
            }
        } else {
            DispatchQueue.main.async {
                button.isEnabled = false
                button.alpha = 0.5
            }
        }
    }
    
    func handleActivityIndicator(indicator: UIActivityIndicatorView, viewController: UIViewController, isActive: Bool) {
        if isActive {
            DispatchQueue.main.async {
                indicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                indicator.stopAnimating()
            }
        }
    }
}
