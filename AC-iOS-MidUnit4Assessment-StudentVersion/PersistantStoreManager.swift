//
//  PersistantStoreManager.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


class PersistentStoreManager {
    static let kPathName = "History.plist"
    private init() {}
    static let manager = PersistentStoreManager()
    private var historys = [[Card]]() {
        didSet {
            saveHistory()
            //TODO: saving to the apps sandbox
        }
    }
    // /documents
    func documentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    // /documents/Favorite
    func dataFilePath(wtih path: String) -> URL {
        return documentsDirectory().appendingPathComponent(path)
    }
    //save
    func saveHistory() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(historys)
            try data.write(to: dataFilePath(wtih: PersistentStoreManager.kPathName))
        } catch {
            print("Encoding error: \(error)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }
    //load
    func load() {
        let path = dataFilePath(wtih: PersistentStoreManager.kPathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: path)
            historys = try decoder.decode([[Card]].self, from: data)
        } catch {
            print("Decoding erorr: \(error.localizedDescription)")
        }
    }
    //add
    
    // appends item to array
    func addToHistory(of cards: [Card]) {
       

        
        // 2) save cards object
        let newHistory = cards
        print("\n~~~~~~~~~~~~~~~~~~~~~")
        print("just add to history: \(newHistory)")
        historys.append(newHistory)
    }

    func getHistory() -> [[Card]] {
        return historys
    }
    
}

