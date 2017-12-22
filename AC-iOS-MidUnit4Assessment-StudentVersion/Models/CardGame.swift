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
    
    private static var deck: Deck?
    
    private static var cards: [Card] = []

    private static var score: Int = 0
    
    weak static var delegate: CardGameDelegate?
    
    static func setDeck(_ deck: Deck) {
        self.deck = deck
    }
    
    static func addCards(_ card: Card) {
        
        guard let cardValue = Int(card.value) else {
            print("Could not get card value")
            return
        }
        
        cards.append(card)
        score += cardValue
    }
    
    static func getDeck() -> Deck {
        return deck!
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
        deck = nil
        cards = []
        score = 0
    }
}
