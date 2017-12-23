//
//  DataStorageModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


struct PastGame: Codable {
    let finalVal: Int
    let cards: [Card]
    let id: Int
}

class PersistenceStoreManager {
    
    static let kPathname = "PastGames.plist"
    private init(){}
    static let manager = PersistenceStoreManager()
    
    private var pastGames = [PastGame]() {
        didSet{
            saveToDisk()
        }
    }
    
    func gameCount() -> Int {
        return pastGames.count
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath(withPathName path: String) -> URL {
        return PersistenceStoreManager.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(pastGames)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: PersistenceStoreManager.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
    }
    
    func load() {
        let path = dataFilePath(withPathName: PersistenceStoreManager.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            pastGames = try decoder.decode([PastGame].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    func addToPastGames(game: PastGame, andImages images: [UIImage]) -> Bool {
        let indexExist = pastGames.index { (pastGame) -> Bool in
            pastGame.id == game.id
        }
        if indexExist != nil { return false }
        
        let success = storeImagesToDisk(images: images, andGame: game)
        if !success { return false }
        
        let newPastGame = PastGame.init(finalVal: game.finalVal, cards: game.cards, id: game.id)
        pastGames.append(newPastGame)
        return true
    }
    // store images
    func storeImagesToDisk(images: [UIImage], andGame game: PastGame) -> Bool {
        // packing data from image
        var imagesData = [Data]()
        for image in images {
            guard let imageData = UIImagePNGRepresentation(image) else { return false }
            imagesData.append(imageData)
        }
        
        
        
        var imagesURLs = [URL]()
        for card in game.cards {
            let imageURL = PersistenceStoreManager.manager.dataFilePath(withPathName: card.code)
            imagesURLs.append(imageURL)
        }
        for index in imagesData.indices {
            do {
                try imagesData[index].write(to: imagesURLs[index])
            } catch {
                print("image saving error: \(error.localizedDescription)")
            }
        }
        return true
    }
    
    
    func isGameInPastGames(game: PastGame) -> Bool {
        let indexExists = pastGames.index{$0.id == game.id}
        return indexExists != nil
    }
    
    
    func getPastGames() -> [PastGame] {
        return pastGames
    }
    
    func deleteAllGames() -> Bool {
        var imagesURLs = [URL]()
        
        let allCardCodes = Array(Set(pastGames.flatMap{$0.cards.map{$0.code}}))
        
        for code in allCardCodes {
            imagesURLs.append(PersistenceStoreManager.manager.dataFilePath(withPathName: "\(code)"))
        }
        
        for imageURL in imagesURLs {
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch {
                print("error removing: \(error.localizedDescription)")
                return false
            }
        }
        pastGames.removeAll()
        return true
    }
    
    
}



