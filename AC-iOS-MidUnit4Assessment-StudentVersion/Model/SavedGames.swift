//  SavedGames.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

struct History: Codable {
	let savedGames: [SavedGame]
}
struct SavedGame: Codable {
	let cards: [SavedCard]
	let score: Int
}
struct SavedCard: Codable {
	let code: String
	let image: String
	let value: String
	let suit: String
	var cardImage: UIImage? {
		set{}
		get {
			let imageURL = DataStorage.manager.dataFilePath(withPathName: image)
			let docImage = UIImage(contentsOfFile: imageURL.path)
			return docImage
		}
	}
}



