//
//  SettingsViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

//extra credit to change target number
class SettingsViewController: UIViewController {

    @IBOutlet weak var targetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetTextField.delegate = self
    }
    
    func presentAlertController(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if "0123456789".contains(string) {
            return true
        }
        
        presentAlertController(withTitle: "ERROR", andMessage: "Please enter only numbers.")
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        guard text.count >= 1 else {
            presentAlertController(withTitle: "ERROR", andMessage: "Please enter at least 1 number.")
            
            return false
        }
        
        guard let intText = Int(text) else {
            presentAlertController(withTitle: "ERROR", andMessage: "Could not save non-integer target.")
            return false
        }
        
        Settings.manager.changeTarget(toNumber: intText)
        presentAlertController(withTitle: "SUCCESS", andMessage: "Changed target number to \(intText).")
        
        textField.text = ""
        
        return true
    }
}
