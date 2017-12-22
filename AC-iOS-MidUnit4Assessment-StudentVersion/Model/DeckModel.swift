//
//  DeckModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DeckModel {
    private init() {}
    static let shared = DeckModel()
    
    private var deck: DeckData?
    
    var deckID: String? {
        return deck?.deckID
    }
    
    var cardEndpoint: String? {
        guard let deckID = deckID else { return "Did no retrieve deck yet!" }
        return "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=1"
    }
    
    func setDeck(_ deck: DeckData) {
        self.deck = deck
    }
    
}

struct DeckData: Codable {
    let shuffled: Bool
    let deckID: String
    let remaining: Int
    let success: Bool
}

extension DeckData {
    enum CodingKeys: String, CodingKey {
        case shuffled
        case deckID = "deck_id"
        case remaining
        case success
    }
}

struct DeckAPIClient {
    private init() {}
    static let manager = DeckAPIClient()
    
    let endpointForDeck = "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=6"
    
    func fetchDeck() {
        DeckAPIClient.manager.getCards(from: DeckAPIClient.manager.endpointForDeck,
                                       completionHandler: {DeckModel.shared.setDeck($0)},
                                       errorHandler: {print($0)})
    }
    
    func getCards(from urlStr: String, completionHandler: @escaping (DeckData) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let deck = try JSONDecoder().decode(DeckData.self, from: data)
                completionHandler(deck)
            }
            catch {
                print(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
}
