//
//  PersistenceHelper.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//
import  UIKit
class DataPersistence {
    
  
    private init() {}
    static let manager = DataPersistence()
    
    let filePath = "HandHistory.plist"
    
    struct Hand: Codable {
        
        let handTotal: Int
        let cards: [Card]
    }
    
   
    private var playedHands = [Hand]() {
        didSet {
            saveHands()
        }
    }
    
  
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   
    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistence.manager.documentsDirectory().appendingPathComponent(path)
    }
    

    func loadHands() {
        var data = Data()
        do {
            data = try Data.init(contentsOf: DataPersistence.manager.dataFilePath(withPathName: filePath))
        } catch {
            print( "\(error.localizedDescription)")
            return
        }
        
        do {
            playedHands = try PropertyListDecoder().decode([Hand].self, from: data)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    private func saveHands() {
        var data = Data()
        
        do {
            data = try PropertyListEncoder().encode(playedHands)
        } catch {
            print("\(error.localizedDescription)")
            return
        }
        
        do {
            try data.write(to: DataPersistence.manager.dataFilePath(withPathName: filePath), options: .atomic)
            
        } catch {
            print(" \(error.localizedDescription)")
        }
        
    }
    func getHands() -> [Hand] {
        return playedHands
    }
  
    func addHand(playedCards: [Card],  handTotal: Int) {
        let hand = Hand(handTotal: handTotal, cards: playedCards)
        playedHands.append(hand)
    }
    
    
    
}
