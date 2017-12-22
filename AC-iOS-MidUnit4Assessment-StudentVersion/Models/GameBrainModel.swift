//
//  GameBrainModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GameBrainModel {
    
    var score = 0
    var goal = 30
    
    func getScore() -> Int {
        return score
    }
    
    func pointsAwayFromGoal() -> Int {
        return goal - score
    }
    
    func resetGame() {
        score = 0
    }
    
    func addCardScore(card: Card) {
        score += cardValue(strValue: card.value)
    }
    
    func didItGoOver() -> Bool {
        return score > goal
    }
    
    func cardValue(strValue: String) -> Int {
        switch strValue {
        case "2":
            return 2
        case "3":
            return 3
        case "4":
            return 4
        case "5":
            return 5
        case "6":
            return 6
        case "7":
            return 7
        case "8":
            return 8
        case "9":
            return 9
        case "10", "JACK", "QUEEN", "KING":
            return 10
        case "ACE":
            return 11
        default:
            return 0
        }
    }
    
}
