//
//  Settings.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class Settings {
    private init() {}
    static let manager = Settings()
    private let defaults = UserDefaults.standard
    private let targetNumberKey = "targetNumberKey"
    
    func changeTarget(toNumber number: Int) {
        defaults.set(number, forKey: targetNumberKey)
    }
    
    //when called, if nil, should return 30 by default - set this up somewhere in game view controller
    func getTargetNumber() -> Int? {
        if let targetNumber = defaults.value(forKey: targetNumberKey) as? Int {
            return targetNumber
        }
        
        return nil
    }
}
