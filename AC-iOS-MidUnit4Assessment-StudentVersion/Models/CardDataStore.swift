//
//  CardDataStore.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Caroline Cruz on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//


import UIKit

class CardDataStore {
    
    static let kPathname = "History.plist"
    
    // singleton
    private init(){}
    static let manager = CardDataStore()
    
    private var recentGames = [RecentGame]() {
        didSet{
            saveToDisk()
        }
    }
    
    // returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // /documents/History.plist
    // returns the path for supplied name from the dcouments directory
    func dataFilePath(withPathName path: String) -> URL {
        return CardDataStore.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    // write to path: /Documents/
    //    encoding goes from object to data
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(recentGames)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: CardDataStore.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }
    
    // load from documents directory
    //    decoding goes from data to object
    func load() {
        // what's the path we are reading from?
        let path = dataFilePath(withPathName: CardDataStore.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            recentGames = try decoder.decode([RecentGame].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    // does 2 tasks:
    // 1. stores image in documents folder
    // 2. appends recent game to array
    func addToHistory(card: RecentGame, andImage image: UIImage) -> Bool  {

        // 1) save image from favorite photo
        let success = storeImageToDisk(image: image, andCard: card)
        if !success { return false }
        
        // 2) save favorite object
        let newRecent = RecentGame.init(image: card.image, value: card.value, suit: card.suit, code: card.code)
       recentGames.append(newRecent)
        return true
    }
    
    // store image
    func storeImageToDisk(image: UIImage, andCard card: RecentGame) -> Bool {
        // packing data from image
        guard let imageData = UIImagePNGRepresentation(image) else { return false }
        
        // writing and saving to documents folder
        
        // 1) save image from favorite photo
        let imageURL = CardDataStore.manager.dataFilePath(withPathName: card.image)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }
    
    
    func getRecentWithId(code: String) -> RecentGame? {
        let index = getRecent().index{$0.code == code}
        guard let indexFound = index else { return nil }
        return recentGames[indexFound]
    }
    
    func getRecent() -> [RecentGame] {
        return recentGames
    }
    
    func removeHistory(fromIndex index: Int, andCardImage recent: RecentGame) -> Bool {
        recentGames.remove(at: index)
        // remove image
        let imageURL = CardDataStore.manager.dataFilePath(withPathName: recent.code)
        do {
            try FileManager.default.removeItem(at: imageURL)
            print("\n==============================================================================")
            print("\(imageURL) removed")
            print("==============================================================================\n")
            return true
        } catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }
    
}

