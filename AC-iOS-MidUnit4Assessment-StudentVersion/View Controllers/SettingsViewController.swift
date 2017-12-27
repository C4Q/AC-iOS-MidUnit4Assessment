//
//  SettingsViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputTextField.delegate = self
        if let setVal = KeyedArchiverClient.manager.getSetting() {
            self.inputTextField.text = "\(setVal)"
            }
    }
    
    @IBAction func saveSetting(_ sender: UIButton) {
        if let textSetting = inputTextField.text, let intSetting = Int(textSetting) {
            KeyedArchiverClient.manager.saveSetting(intSetting)
            let alert = UIAlertController(title: "Settings", message: "You are changed to \(intSetting)", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
