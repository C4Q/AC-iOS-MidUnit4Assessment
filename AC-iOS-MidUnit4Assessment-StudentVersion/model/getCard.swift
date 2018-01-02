//
//  getCard.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/25/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardInfo: Codable {
    let cards: [Card]
}

struct Card: Codable {
    let image: String?
    let value: String
    let code: String
}

struct getCardAPIClient {
    private init() {}
    static let manager = getCardAPIClient()
    func getCard(from urlStr: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                let myDecoder = JSONDecoder()
                
                let  cardInfo = try myDecoder.decode(CardInfo.self, from: data)
                completionHandler(cardInfo.cards.first!)
                
            } catch{
                print(error)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}

