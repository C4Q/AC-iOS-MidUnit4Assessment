//  SavedGames.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

struct SavedGame: Codable {
	let cards: [Card]
	let score: Int
	init(cards: [Card], score: Int){
		self.cards = cards
		self.score = score
	}
}




