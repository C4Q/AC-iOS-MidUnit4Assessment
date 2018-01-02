//
//  GameBrain.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
enum GameState {
    case win
    case lose
    case playing
}
class GameBrain {
    private init() {}
    static let manager = GameBrain()
    var hand = [Card]()
    var currentTotal = 0
    let victoryTotal = 30
    var deck: Deck!
    var currentDraw: Card?
    
    //get deck from online by using API Client.
    func setUpDeck() {
        let setDeckFromOnline = {(onlineDeck: Deck) in
            self.deck = onlineDeck
            
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        DeckAPIClient.manager.getDeck(completionHandler: setDeckFromOnline, errorHandler: printErrors)
        
        
    }
    func draw() {
        let cardFromOnline = {(onlineCard: Card) in
            self.currentDraw = onlineCard
            
            if let currentDrawSafe = self.currentDraw {
                self.currentTotal += currentDrawSafe.realValue
                self.hand.append(currentDrawSafe)}
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        //Get the next card using the deck id

        CardAPICLient.manager.getCard(with: self.deck.deckID, completionHandler: cardFromOnline, errorHandler: printErrors)
    }
    func getCurrentHand() -> [Card] {
        return self.hand
    }
    func victoryCheck(currentTotal: Int) -> GameState {
        
        if currentTotal == victoryTotal {
            return .win
        } else if currentTotal > victoryTotal {
            return .lose
        } else {
            return .playing
        }
        
    }
    
    func clearCurrentGame() {
        currentTotal = 0
        hand = []
        setUpDeck()
        
    }
    
}
