//
//  PersistenceHelper.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

struct Hand: Codable {
    let totalValue: Int 
    let cards: [Card]
}
class Persistence {
static let kPathName = "hands.plist"
private init() {}
static let manager = Persistence()
    
    private var usedHands = [Hand]() {
        didSet {
            saveHand()
        }
    }
    
    // returns documents directory path for app
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath(withPathName path: String) -> URL {
        return Persistence.manager.documentsDirectory().appendingPathComponent(path)
    }
    func saveHand() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(usedHands)
            try data.write(to: dataFilePath(withPathName: Persistence.kPathName), options: .atomic)
        }
        catch {
            print("encoding error: \(error.localizedDescription)")
        }
    }
    func addHand(cards: [Card], total: Int) {
        
        let newHand = Hand.init(totalValue: total, cards: cards)
        usedHands.append(newHand)
    }
    func getHands() -> [Hand] {
        return self.usedHands
    }
    func loadHand(){
        let path = dataFilePath(withPathName: Persistence.kPathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            usedHands = try decoder.decode([Hand].self, from: data)
        }
        catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    
    
    
}
