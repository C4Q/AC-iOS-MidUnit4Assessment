//  UserDefaults.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/23/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation

struct UserDefaultsHelper {
	private init() {}
	static let manager = UserDefaultsHelper()

	private let defaults = UserDefaults.standard

	func setWinningNumber(value: Int){
		defaults.set(value, forKey: "winningNumber")
	}

	func getWinningNumber() -> Int? {
		return defaults.value(forKey: "winningNumber") as? Int
	}

}
