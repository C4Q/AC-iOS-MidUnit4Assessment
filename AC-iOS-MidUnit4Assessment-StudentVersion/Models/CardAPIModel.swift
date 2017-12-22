//
//  CardAPIModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct NewDeck: Codable {
    var shuffled: Bool
    var deckID: String
    enum CodingKeys: String, CodingKey {
        case shuffled = "shuffled"
        case deckID = "deck_id"
    }
}

struct CardsWrapper: Codable {
    var cards: [Card]
}

struct Card: Codable {
    var code: String
    var imageLink: String
    var value: String
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case imageLink = "image"
        case value = "value"
    }
}

//API for NewDeck
struct NewDeckAPIClient {
    private init() {}
    static let manager = NewDeckAPIClient()
    private let urlStr = "https://deckofcardsapi.com/api/deck/new/"
    func getNewDeck(
        completionHandler: @escaping ([NewDeck]) -> Void,
        errorHandler: @escaping (Error) -> Void) {
        
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(NewDeck.self, from: data) //THIS IS ALWAYS THE TOP LAYER OF JSON
                let newDeck = [results]
                completionHandler(newDeck)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCards, errorHandler: errorHandler)
    }
}
//API for shuffling new deck
struct ShuffledDeckAPIClient {
    private init() {}
    static let manager = ShuffledDeckAPIClient()
    
    func getShuffledDeck(fromDeckID deckID: String,
        completionHandler: @escaping ([NewDeck]) -> Void,
        errorHandler: @escaping (Error) -> Void) {
        
        let fullUrlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/shuffle/"
        guard let url = URL(string: fullUrlStr) else {
            errorHandler(AppError.badURL(str: fullUrlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoShuffledCards: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(NewDeck.self, from: data) //THIS IS ALWAYS THE TOP LAYER OF JSON
                let ShuffledCards = [results]
                completionHandler(ShuffledCards)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoShuffledCards, errorHandler: errorHandler)
    }
}

//API for CurrentDeck
//Make function take in a string - that string will be the deckID. interpolate the endpoint with it
struct CardsAPIClient {
    private init() {}
    static let manager = CardsAPIClient()
    func getACard(fromDeckID deckID: String,
        completionHandler: @escaping ([Card]) -> Void,
        errorHandler: @escaping (Error) -> Void) {
        
        let fullUrlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
        guard let url = URL(string: fullUrlStr) else {
            errorHandler(AppError.badURL(str: fullUrlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(CardsWrapper.self, from: data) //THIS IS ALWAYS THE TOP LAYER OF JSON
                let cardsArray = results.cards
                completionHandler(cardsArray)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCards, errorHandler: errorHandler)
    }
}

