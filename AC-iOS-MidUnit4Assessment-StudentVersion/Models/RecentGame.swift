//
//  RecentGame.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


import UIKit

struct RecentGame: Codable {
    let image: String
    let value: String
    let suit: String
    let code: String


    // computed property to return image from documents
    var cardImage: UIImage? {
        set{}
        get {
            let imageURL = CardDataStore.manager.dataFilePath(withPathName: code)
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
}
