//
//  CardIdentityAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CardIdentity: Codable {
    let deckID: String
    
    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
    }
}

struct DeckIdentityAPIClient {
    private init() {}
    static let manager = DeckIdentityAPIClient()
    let idUrl = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
    func getCardIdentity(from urlStr: String, completionHandler: @escaping (CardIdentity) -> Void, errorHandler: @escaping (AppError) -> Void){


        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }

        let completion: (Data) -> Void = {(data: Data) in

            do{
                let myDecoder = JSONDecoder()

                let  myDeckID = try myDecoder.decode(CardIdentity.self, from: data)
                completionHandler(myDeckID)

            } catch {
                print(Error.self)
                errorHandler(.couldNotParseJSON)

            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}

