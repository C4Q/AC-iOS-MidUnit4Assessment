//
//  CardGame.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//model for card game

protocol CardGameDelegate: class {
    func saveGame(withCards cards: [Card], score: Int, andTargetScore targetScore: Int)
}

class CardGame {
    enum GameStatus {
        case ongoing
        case victory
        case defeat
    }
    
    private static var cards: [Card] = []

    private static var score: Int = 0
    
    weak static var delegate: CardGameDelegate?
    
    static var cardValueDict: [String : Int] = [
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        "10": 10,
        "JACK" : 10,
        "QUEEN" : 10,
        "KING" : 10,
        "ACE" : 11
        ]
    
    static func addCard(_ card: Card) {
        
        guard let cardValue = cardValueDict[card.value] else {
            print("could not get card value")
            return
        }
        
        cards.append(card)
        score += cardValue
    }
    
    static func getCards() -> [Card] {
        return cards
    }
    
    static func getScore() -> Int {
        return score
    }
    
    //use this if user stops game prematurely
    static func stopGame() -> (score: Int, targetScore: Int) {
        let currentTargetScore = Settings.manager.getTargetNumber() ?? 30
        
        delegate?.saveGame(withCards: cards, score: score, andTargetScore: currentTargetScore)
        
        return (score, currentTargetScore)
    }
    
    static func checkForWin() -> GameStatus {
        let currentTargetScore = Settings.manager.getTargetNumber() ?? 30
        
        if score < currentTargetScore {
            return .ongoing
        } else {
            //use delegate to save scores and cards!!
            delegate?.saveGame(withCards: cards, score: score, andTargetScore: currentTargetScore)
            if score == currentTargetScore {
                return .victory
            } else {
                return .defeat
            }
        }
    }
    
    static func resetGame() {
        cards = []
        score = 0
    }
}
