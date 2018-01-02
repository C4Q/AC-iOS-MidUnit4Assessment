//
//  getDeckAPI.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/25/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct DeckInfo: Codable {
    let deckId: String
    
    enum CodingKeys: String, CodingKey {
        case deckId = "deck_id"
    }
    //    static let defaultId = DeckInfo(deckId: "j7az39yq9y2a")
}

struct GetDeckAPIClient{
    private init() {}
    static let manager = GetDeckAPIClient()
    func getDeck(from urlStr: String, completionHandler: @escaping (DeckInfo) -> Void, errorHandler: @escaping (AppError) -> Void){
        
        
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                
                let  deckId = try JSONDecoder().decode(DeckInfo.self, from: data)
                completionHandler(deckId)
                
            } catch{
                print(error)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}



