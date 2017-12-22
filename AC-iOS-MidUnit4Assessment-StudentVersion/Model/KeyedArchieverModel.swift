//
//  KeyedArchieverModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class KeyedArchiverClient {
    
    static let shared = KeyedArchiverClient()
    private init() {}
    
    static let plistPathName = "HistoryOfHands.plist"
    
    var currentTableViewIndex = 0
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    private func dataFilePath(pathName: String) -> URL {
        return KeyedArchiverClient.shared.documentsDirectory().appendingPathComponent(pathName)
    }
    
        private var hands = [[Card]]() {
            didSet {
                saveFavorites()
            }
        }
    
    //    save
    func saveFavorites() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(hands)
            try data.write(to: dataFilePath(pathName: KeyedArchiverClient.plistPathName), options: .atomic)
        } catch {
            print("Encoder error: \(error.localizedDescription)")
        }
    }
    
    //    load
    func loadFavorites() {
        let decoder = PropertyListDecoder()
        let path = dataFilePath(pathName: KeyedArchiverClient.plistPathName)
        do {
            let data = try Data.init(contentsOf: path)
            hands = try decoder.decode([[Card]].self, from: data)
        } catch {
            print("Decoder error: \(error.localizedDescription)")
        }
    }
    
    //    add
    func addHandToHistory(hand: [Card]) {
        hands.append(hand)
    }
    
    //    reset
    func resetHistory() {
        hands = [[Card]]()
    }
    
    //    read
    func getHands() -> [[Card]] {
        return hands
    }
    
}
