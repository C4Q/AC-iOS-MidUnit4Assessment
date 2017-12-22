//
//  DeckOfCardsAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DeckOfCardsAPIClient {
    
    private init() {}
    static let manager = DeckOfCardsAPIClient()
    
    func getCards(completionHandler: @escaping ([Card]) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        
        let deckOfCardsUrl = "https://deckofcardsapi.com/api/deck/new/draw/?count=52"
        
        guard let url = URL(string: deckOfCardsUrl) else { errorHandler(AppError.badUrl); return }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: {
                                                do {
                                                    let json = try  JSONDecoder().decode(CardWrapper.self, from: $0)
                                                    completionHandler(json.cards)
                                                } catch {
                                                    errorHandler(AppError.codingError(rawError: error))
                                                }
        }, errorHandler: errorHandler)
        
    }
    
    
}
