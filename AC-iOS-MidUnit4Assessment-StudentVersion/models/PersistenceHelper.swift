//
//  PersistenceHelper.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//
import  UIKit
class Persistence {
    
  
    private init() {}
    static let manager = Persistence()
    
    let filePath = "HandHistory.plist"
    
    struct Hand: Codable {
        
        let handTotal: Int
        let cards: [Card]
    }
    
   
    private var pastHands = [Hand]() {
        didSet {
            saveHands()
        }
    }
    
  
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   
    private func dataFilePath(withPathName path: String) -> URL {
        return Persistence.manager.documentsDirectory().appendingPathComponent(path)
    }
    

    func loadHands() {
        var data = Data()
        do {
            data = try Data.init(contentsOf: Persistence.manager.dataFilePath(withPathName: filePath))
        } catch {
            print( "\(error.localizedDescription)")
            return
        }
        
        do {
            pastHands = try PropertyListDecoder().decode([Hand].self, from: data)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    private func saveHands() {
        var data = Data()
        
        do {
            data = try PropertyListEncoder().encode(pastHands)
        } catch {
            print("\(error.localizedDescription)")
            return
        }
        
        do {
            try data.write(to: Persistence.manager.dataFilePath(withPathName: filePath), options: .atomic)
            
        } catch {
            print(" \(error.localizedDescription)")
        }
        
    }
    func getHands() -> [Hand] {
        return pastHands
    }
  
    func addHand(playedCards: [Card],  handTotal: Int) {
        let hand = Hand(handTotal: handTotal, cards: playedCards)
        pastHands.append(hand)
    }
    func delete() {
        pastHands.removeAll()
    }
    
    
}
