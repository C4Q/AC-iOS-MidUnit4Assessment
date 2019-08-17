//
//  CardModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//using "new" will create a shuffled deck and draw cards from that deck in the same request.
//new card: "https://deckofcardsapi.com/api/deck/new/draw/?count=1"


//card image example: "https://deckofcardsapi.com/static/img/KH.png"

//https://deckofcardsapi.com/static/img/\(code).png

struct PlayingCards: Codable {
    let cards: [CardInfo]
}

struct CardInfo: Codable {
    let code: String
    let image: String
    let value: String
    let suit: String
    let images: ImageWrapper
    //static let noDataCard = CardInfo(value: 0)
    // this is just testing to see if the .xib file is working
    /* Use for testing
     static let testPixabays = [Pixabay(likes: 1, tags: "Test One"),
     Pixabay(likes: 2, tags: "Test Two"),
     Pixabay(likes: 3, tags: "Test Three")
     ]*/
//    static let testCards = [CardInfo.init(value: "1"),
//                            CardInfo.init(value: "2"),
//                            CardInfo.init(value: "3")]
}

struct ImageWrapper: Codable {
    let png: String
}





