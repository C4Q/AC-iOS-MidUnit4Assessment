//
//  DataPersistenceHelper.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DataPersistenceHelper {
    
    // Singleton
    private init() {}
    static let manager = DataPersistenceHelper()
    
    let filePath = "HandHistory.plist"
    
    struct Hand: Codable {
        let target: Int
        let handTotal: Int
        let cards: [Card]
    }
    
    // Save hands everytime it changes
    private var playedHands = [Hand]() {
        didSet {
            saveHands()
        }
    }
    
    // Gets the doc dir path
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Gets the file path in doc dir
    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistenceHelper.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // Loads the hands into this object
    func loadHands() {
        var data = Data()
        do {
            data = try Data.init(contentsOf: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath))
        } catch {
            print("Error retrieving data. \(error.localizedDescription)")
            return
        }
        
        do {
            playedHands = try PropertyListDecoder().decode([Hand].self, from: data)
        } catch {
            print("Plist decoding error. \(error.localizedDescription)")
        }
    }
    
    // Returns this object's array of hands
    func getHands() -> [Hand] {
        return playedHands
    }
    
    // Saves current array of hands into a plist into the doc dir
    private func saveHands() {
        var data = Data()
        
        do {
            data = try PropertyListEncoder().encode(playedHands)
        } catch {
            print("Plist encoding error. \(error.localizedDescription)")
            return
        }
        
        do {
            try data.write(to: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath), options: .atomic)
            
        } catch {
            print("Writing to disk error. \(error.localizedDescription)")
        }
        
    }
    
    // Appends an object to hands array
    // Also saves the image in the doc dir
    func addHand(playedCards: [Card], target: Int, handTotal: Int) {
        let hand = Hand(target: target, handTotal: handTotal, cards: playedCards)
        playedHands.append(hand)
    }
    
    // Deletes saved hands
    func deleteHands() {
        playedHands.removeAll()
    }
    
}
