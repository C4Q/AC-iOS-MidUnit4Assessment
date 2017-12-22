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

}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if "0123456789".contains(string) {
            return true
        }
        
        let alertController = Alert.createAlertController(withTitle: "ERROR", andMessage: "Please enter only numbers.")
        
        self.present(alertController, animated: true, completion: nil)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        guard text.count >= 1 else {
            let alertController = Alert.createAlertController(withTitle: "ERROR", andMessage: "Please enter at least 1 number.")
            
            self.present(alertController, animated: true, completion: nil)

            return false
        }
        
        guard let intText = Int(text) else {
            let alertController = Alert.createAlertController(withTitle: "ERROR", andMessage: "Could not save non-integer target.")
            
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        Settings.manager.changeTarget(toNumber: intText)
        
        let alertController = Alert.createAlertController(withTitle: "SUCCESS", andMessage: "Changed target number to \(intText).")
        
        self.present(alertController, animated: true, completion: nil)
        
        textField.text = ""
        
        return true
    }
}
