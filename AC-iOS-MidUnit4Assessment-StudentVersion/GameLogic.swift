//
//  GameLogic.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation



class GameLogic {
    
    var totalScore = 0
    
    
    func cardValueConverter(value: String) -> String {
        
        
        var cardValue = ""
        
        switch value {
        case "King":
            cardValue = "10"
        case "Queen":
            cardValue = "10"
        case "Jack":
            cardValue = "10"
        case "Ace":
            cardValue = "11"
        default:
            break
        }
        return cardValue
    }
    
    func getScore(value: String) -> Int {
        let cardScore = Int(value)
        totalScore += cardScore!
        return totalScore
    }
    
    func gameStatus(score: Int ) -> Bool {
        if score > 30 {
            gameOver()
            return true
        } else {
            return false
        }
    }
    
    func newGame() {
        totalScore = 0
    }
    
    func gameOver() {
        newGame()
    }
    
    
    
}









