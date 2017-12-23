//
//  PlayingCardsAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class PlayingCardsAPIClient {
    private init() {}
    static let manager = PlayingCardsAPIClient()
    
    private var currentDeckID = UserDefaults.standard.string(forKey: "deckID") {
        didSet {
            UserDefaults.standard.set(currentDeckID, forKey: "deckID")
        }
    }
    
    func getNewDeck(completionHandler: @escaping () -> (),
            errorHandler: @escaping (Error) -> Void) {
        
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badUrl(str: urlStr)); return
        }
        let request = URLRequest(url: url)
        
        let parseDataIntoNewID: (Data) -> Void = { data in
            do {
                let response = try JSONDecoder().decode(NewDeckAPIResponse.self, from: data)
                self.currentDeckID = response.deckID
                completionHandler()
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoNewID, errorHandler: errorHandler)
    }
    
    func getNewCard(completionHandler: @escaping (Card) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        guard let currentDeckID = currentDeckID else {
            errorHandler(AppError.defaultsNotSet); return
        }
        let urlStr = "https://deckofcardsapi.com/api/deck/\(currentDeckID)/draw/?count=1"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badUrl(str: urlStr)); return
        }
        let request = URLRequest(url: url)
        
        let parseDataIntoCard: (Data) -> Void = { data in
            do {
                let response = try JSONDecoder().decode(DrawCardAPIResponse.self, from: data)
                completionHandler(response.cards.first!)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCard, errorHandler: errorHandler)
    }
    
    func resetDeck(errorHandler: @escaping (Error) -> Void) {
        guard let currentDeckID = currentDeckID else {
            errorHandler(AppError.defaultsNotSet)
            return
        }
        let urlStr = "https://deckofcardsapi.com/api/deck/\(currentDeckID)/shuffle/"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badUrl(str: urlStr)); return
        }
        let request = URLRequest(url: url)
        
        let checkForValidID: (Data) -> Void = { data in
            do {
                let response = try JSONDecoder().decode(NewDeckAPIResponse.self, from: data)
                guard response.success else {
                    errorHandler(AppError.noJSONmaybe)
                    return
                }
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        
        NetworkHelper.manager.performDataTask(with: request, completionHandler: checkForValidID, errorHandler: errorHandler)
    }
}

