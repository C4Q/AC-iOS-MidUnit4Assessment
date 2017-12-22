//
//  Card.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct CardResults: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    
    var realValue: Int {
        switch value {
        case "JACK" :
            return 10
        case "QUEEN" :
            return 10
        case "KING" :
            return 10
        case "ACE" :
            return 11
        default :
            return Int(value)!
        }
    }
}

struct CardAPICLient {
    private init() {}
    static let manager = CardAPICLient()
    func getCard(with deckID: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let request = URLRequest(url:url)
        let parseDataIntoCard: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(CardResults.self, from: data)
                let card = results.cards[0]
                completionHandler(card)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCard, errorHandler: errorHandler)
        
        
    }
   
}
