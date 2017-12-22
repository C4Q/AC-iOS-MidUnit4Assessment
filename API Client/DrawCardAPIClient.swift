//
//  DrawCardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct DrawCard: Codable {
    let cards: [CardDetails]
}

struct CardDetails: Codable {
    let code: String
    let imageUrl: String
    let value: String
    let suit: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case imageUrl = "image"
        case value
        case suit
    }
}
    

struct DrawCardAPIClient {
    private init () {}
    static let manager = DrawCardAPIClient()
    
    func getACard(deckId: String, completionHandler: @escaping ([CardDetails]) -> Void , errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=1"
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let newcard = try JSONDecoder().decode(DrawCard.self, from: data)
                completionHandler(newcard.cards)
            } catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
