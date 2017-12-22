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
    func getOneCard(deckID: String,
                  completionHandler: @escaping ([Card]) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        
        let urlStr = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let myDecoder = JSONDecoder()
                let myCards = try myDecoder.decode([Card].self, from: data)
                completionHandler(myCards)
            } catch {
                errorHandler(AppError.couldNotParseJSON)
                print(errorHandler)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}


