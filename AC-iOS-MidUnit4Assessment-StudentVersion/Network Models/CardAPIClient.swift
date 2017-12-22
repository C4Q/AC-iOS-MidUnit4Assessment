//
//  CardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Cards: Codable {
    let cards: [CardInfo]
}

struct CardInfo: Codable {
    let image: String
    let value: String
    let suit: String
}

struct CardAPIClient {
    private init() {}
    static let manager = CardAPIClient()
    let cardsUrl = "https://deckofcardsapi.com/api/deck/7vlk6gflplio/draw/?count=1"
    func getCards(from urlStr: String, completionHandler: @escaping ([CardInfo]) -> Void, errorHandler: @escaping (AppError) -> Void){
        
        
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                let myDecoder = JSONDecoder()
                
                let  myCardInfo = try myDecoder.decode(CardInfo.self, from: data)
                completionHandler([myCardInfo])
                
            } catch {
                print(Error.self)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
