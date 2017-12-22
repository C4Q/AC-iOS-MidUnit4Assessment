//
//  PersistentData.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class PersistentData {
    private init() {}
    static let manager = PersistentData()
    
    private let cardsPListName = "CardGames.plist"
    private let scoresPListName = "Scores.plist"
    
    private var cardGames: [[Card]] = [] {
        didSet {
            saveCardGames()
        }
    }
    private var scores: [(score: Int, targetScore: Int)] = [] {
        didSet {
            saveScores()
        }
    }
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath(of fileName: String) -> URL {
        return documentDirectory().appendingPathComponent(fileName)
    }
    
    //save
    func saveCardGames() {
        let filePath = dataFilePath(of: cardsPListName)
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(cardGames)
            
            try data.write(to: filePath)
        } catch let error {
            print(error)
        }
        
    }
    
    func saveScores() {
        let filePath = dataFilePath(of: scoresPListName)
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(scores)
            
            try data.write(to: filePath)
        } catch let error {
            print(error)
        }
    }
    
    func saveImage(_ image: UIImage, withURL urlString: String) {
        let filePath = dataFilePath(of: urlString)
        
        guard let imageData = UIImagePNGRepresentation(image) else {
            print("Could not turn image into data")
            return
        }
        
        do {
            try imageData.write(to: filePath)
        } catch let error {
            print(error)
        }
    }
    
    //load
    func loadCardGames() {
        let filePath = dataFilePath(of: cardsPListName)
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data.init(contentsOf: filePath)
            let cardGames = try decoder.decode([[Card]].self, from: data)
            
            self.cardGames = cardGames
        } catch let error {
            print(error)
        }
    }
    
    func loadScores() {
        let filePath = dataFilePath(of: scoresPListName)
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data.init(contentsOf: filePath)
            let scores = try decoder.decode([(Int, Int)].self, from: data)
            
            self.scores = scores
        } catch let error {
            print(error)
        }
    }
    
    //add
    func addCardGame(_ newGame: [Card]) {
        cardGames.append(newGame)
    }
    
    func addScore(_ newScore: (score: Int, targetScore: Int)) {
        scores.append(newScore)
    }
    
    //get
    func getSavedCardGames() -> [[Card]] {
        return cardGames
    }
    
    func getSavedScores() -> [(score: Int, targetScore: Int)] {
        return scores
    }
    
    func getImage(withURL urlString: String) -> UIImage? {
        let filePath = dataFilePath(of: urlString).path
        
        guard let image = UIImage(contentsOfFile: filePath) else {
            return nil
        }
        
        return image
    }
    
    //remove
    func removeCardGames() {
        cardGames = []
    }
    
    func removeScores() {
        scores = []
    }
    
}
