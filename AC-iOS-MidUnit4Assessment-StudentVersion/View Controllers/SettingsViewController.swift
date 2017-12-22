//
//  SettingsViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // Outlets
    @IBOutlet weak var textField: UITextField!
    
    // When this variable is changed it creates a userdefault with this value
    var numberEntry = 0 {
        didSet {
            let target = UserDefaultsHelper.MyDefaults.init(targetAmount: numberEntry)
            UserDefaultsHelper.manager.createDefaultSetting(value: target)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        if let defaults = UserDefaultsHelper.manager.getValue() {
            textField.text = defaults.targetAmount.description
        }
        
    }
    
}

// MARK: - Helper Functions

extension SettingsViewController {
    
    func alertController(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - TextField

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        guard let int = Int(text) else { alertController(title: "Incorrect Format", message: "Please enter using digits only."); return false }
        guard 2 < int && int < 347 else { alertController(title: "Bad Number", message: "Please enter a number between 2 and 347."); return false }
        numberEntry = int
        textField.resignFirstResponder()
        return true
    }
    
    
}
