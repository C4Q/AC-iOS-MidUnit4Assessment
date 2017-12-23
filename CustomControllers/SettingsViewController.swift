//
//  SettingsViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func valChanged(_ sender: UIStepper) {
        UserDefaults.standard.set(Int(stepper.value), forKey: "target")
        targetLabel.text = "BlackJack Target: \(target)"
    }
    
    var target: Int {
        if UserDefaults.standard.integer(forKey: "target") == 0 {
            return 30
        } else {
            return UserDefaults.standard.integer(forKey: "target")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.value = Double(target)
        targetLabel.text = "BlackJack Target: \(target)"
    }
}
