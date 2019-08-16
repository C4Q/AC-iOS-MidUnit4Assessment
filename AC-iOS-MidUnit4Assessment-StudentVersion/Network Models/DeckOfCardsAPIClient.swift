//
//  DeckOfCardsAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct DeckOfCardsAPIClient{
    private init() {}
    static let manager = DeckOfCardsAPIClient()
    func getDeckOfCards(from urlStr: String, completionHandler: @escaping (DeckOfCards) -> Void, errorHandler: @escaping (AppError) -> Void){


        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }

        let completion: (Data) -> Void = {(data: Data) in

            do{
                let myDecoder = JSONDecoder()

                let  myDeck = try myDecoder.decode(DeckOfCards.self, from: data)
                completionHandler(myDeck)

            } catch{
                print(error)
                errorHandler(.couldNotParseJSON)

            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
