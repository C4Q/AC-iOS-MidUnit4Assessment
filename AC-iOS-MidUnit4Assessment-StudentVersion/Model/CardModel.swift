//
//  CardModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CardModel {
    private init() {}
    static let shared = CardModel()
    
    private var cards = [Card]()
    
    func addCard(_ cards: CardData) {
        guard let card = cards.cards.first else { return }
        self.cards.append(card)
    }
    
    func viewCards() -> [Card] {
        return cards
    }
    
    func resetCards() {
        cards = [Card]()
    }
    
}

struct CardData: Codable {
    let cards: [Card]
    let deckID: String
    let remaining: Int
    let success: Bool
}

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    let suit: String
    let images: Images
}

struct Images: Codable {
    let svg: String
    let png: String
}

extension CardData {
    enum CodingKeys: String, CodingKey {
        case cards = "cards"
        case deckID = "deck_id"
        case remaining = "remaining"
        case success = "success"
    }
}

extension Card {
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case image = "image"
        case value = "value"
        case suit = "suit"
        case images = "images"
    }
}

extension Images {
    enum CodingKeys: String, CodingKey {
        case svg = "svg"
        case png = "png"
    }
}



struct CardAPIClient {
    private init() {}
    static let manager = CardAPIClient()
    func getCards(from urlStr: String, completionHandler: @escaping (CardData) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let cards = try JSONDecoder().decode(CardData.self, from: data)
                completionHandler(cards)
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


