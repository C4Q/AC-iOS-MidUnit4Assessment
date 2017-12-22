//
//  CardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct CardAPIClient{
    private init() {}
    static let manager = CardAPIClient()
    func getCard(from urlStr: String, completionHandler: @escaping (Card) -> Void, errorHandler: @escaping (AppError) -> Void){


        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }

        let completion: (Data) -> Void = {(data: Data) in

            do{
                let myDecoder = JSONDecoder()

                let  mycards = try myDecoder.decode(cards.self, from: data)
                
                completionHandler(mycards.cards[0])

            } catch{
                print(error)
                errorHandler(.couldNotParseJSON)

            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }

}
