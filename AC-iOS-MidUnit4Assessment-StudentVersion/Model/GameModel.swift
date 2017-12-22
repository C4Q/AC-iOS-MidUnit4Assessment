//
//  GameModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
enum GameState {
    case ongoing
    case won
    case lost
}

class GameModel {
    private init() {}
    static let manager = GameModel()
    
    func stopGame() -> GameState {
        return checkIfWon()
    }
    
    func checkIfWon() -> GameState {
        if valueOfHand > 30 {
            return lostGame()
        } else if valueOfHand == 30 {
            return wonGame()
        }
        return .ongoing
    }
    
    func lostGame() -> GameState {
        
        return .lost
    }
    
    func wonGame() -> GameState {
        
        return .won
    }
    
    let winningHandValue = 30
    
    var currentHand: [Card] {
        return CardModel.shared.viewCards()
    }
    
    var valueOfHand: Int {
        return currentHand.reduce(0, {$0 + (cardValues[$1.value] ?? 0)})
    }
    
    let cardValues: [String: Int] = [
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        "10": 10,
        "JACK": 10,
        "QUEEN": 10,
        "KING": 10,
        "ACE": 11
    ]
    
}
