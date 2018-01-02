//
//  GameModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/25/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GameBrain {
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
    

    var target: Int = 0
    var totalValueAtHand = 0
    
    func startNewGame() {
        totalValueAtHand = 0
        
    }
}
