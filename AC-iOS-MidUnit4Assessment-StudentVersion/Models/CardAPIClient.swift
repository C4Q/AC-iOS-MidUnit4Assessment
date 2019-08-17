//
//  CardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CardAPIClient {
    private init(){}
    static let manager = CardAPIClient()
    
    func getOneNewCard(from completionHandler: @escaping ([CardInfo]) -> Void,
                     errorHandler: @escaping (Error) -> Void){//set signature
        //endpoint to get deck of cards: will shuffle the deck everytime you draw a new card
        let urlStr = "https://deckofcardsapi.com/api/deck/new/draw/?count=1"
        //make sure you have a url
        guard let url = URL(string: urlStr) else {return}
        //make request for URL from url
        let request = URLRequest(url: url)
        //set completion
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do{
                let decoder = JSONDecoder()
                let results = try decoder.decode(PlayingCards.self, from: data)
                let cards = results.cards
                completionHandler(cards)
                print("JSON Data is now an [CardInfo]")
                for card in cards{
                    print(card.suit, card.value)
                }
                
            }catch{
                //errorHandler
            }
        }
        //NetworkHelperCall
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoCards,
                                              errorHandler: errorHandler)
    }

    
    func getNewCardDeck(from completionHandler: @escaping (CardDeckInfo) -> Void,
                     errorHandler: @escaping (Error) -> Void){//set signature
        //endpoint to get deck of cards: will shuffle the decks
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        //make sure you have a url
        guard let url = URL(string: urlStr) else {return}
        //make request for URL from url
        let request = URLRequest(url: url)
        //set completion
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do{
                let decoder = JSONDecoder()
                let results = try decoder.decode(CardDeckInfo.self, from: data)
                let cardDeck = results
                completionHandler(cardDeck)
                print("JSON Data is now 6 card decks")
                print(results.deckID)
            }catch{
                //errorHandler
            }
        }
        //NetworkHelperCall
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoCards,
                                              errorHandler: errorHandler)
    }
}

