//
//  GameModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct GameModel {

    static let cardValues: [String: Int] = ["2": 2,
                                            "3": 3,
                                            "4": 4,
                                            "5": 5,
                                            "6": 6,
                                            "7": 7,
                                            "8": 8,
                                            "9": 9,
                                            "10": 10,
                                            "JACK": 10,
                                            "QUEEN": 10,
                                            "KING": 10,
                                            "ACE": 11]
    
    //let cardV["five"] = 5
    
    static var pointsToWin = 30
    static var currentPoints = 0
}
