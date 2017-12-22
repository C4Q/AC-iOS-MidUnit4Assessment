//
//  BlackjackGameBrain.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class BlackjackGameBrain {
    
    // Init class with target
    var target: Int
    
    // Array to hold player cards
    private var cardArray = [Int]()
    
    // Total value of player cards
    var cardTotal: Int {
        return cardArray.reduce(0, +)
    }
    
    // See if total is over target
    var totalIsOverTarget: Bool {
        return cardTotal > target
    }
    
    // Check if winner
    var winner: Bool {
        return cardTotal == target
    }
    
    // Add card to array
    func addCard(cardValue: Int) {
        cardArray.append(cardValue)
    }
    
    // Dict to convert strings to ints
    let cardValues: [String : Int] = ["1" : 1,
                                      "2" : 2,
                                      "3" : 3,
                                      "4" : 4,
                                      "5" : 5,
                                      "6" : 6,
                                      "7" : 7,
                                      "8" : 8,
                                      "9" : 9,
                                      "10" : 10,
                                      "JACK" : 10,
                                      "QUEEN" : 10,
                                      "KING" : 10,
                                      "ACE" : 11]
    
    init(target: Int) {
        self.target = target
    }
    
}
