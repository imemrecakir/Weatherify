//
//  UIViewController+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 1.03.2024.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardView))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboardView() {
        view.endEditing(true)
    }
}
