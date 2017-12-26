//
//  SettingsViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var targetScoreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.targetScoreTextField.delegate = self
        if let targetScore = UserDefaults.standard.value(forKey: UserDefaultsKeys.targetScore.rawValue) as? Int {
            targetScoreTextField.text = targetScore.description
        }
    }

}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textInTextfield = textField.text else {
            messageLabel.text = "Not a valid target score"
            return false
        }
        guard let numTarget = Int(textInTextfield) else {
            messageLabel.text = "Not a valid target score"
            return false
        }
        UserDefaults.standard.set(numTarget, forKey: UserDefaultsKeys.targetScore.rawValue)
        messageLabel.text = "Target score changed to \(numTarget)"
        textField.resignFirstResponder()
        return true
    }
    
}
