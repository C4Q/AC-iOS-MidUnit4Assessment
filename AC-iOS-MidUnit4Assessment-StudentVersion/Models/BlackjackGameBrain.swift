//
//  BlackjackGameBrain.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class BlackjackGameBrain {
    
    var target: Int
    
    private var cardArray = [Int]()
    
    var cardTotal: Int {
        return cardArray.reduce(0, +)
    }
    
    var totalIsOverTarget: Bool {
        return cardTotal > target
    }
    
    var winner: Bool {
        return cardTotal == target
    }
    
    func addCard(cardValue: Int) {
        cardArray.append(cardValue)
    }
    
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
