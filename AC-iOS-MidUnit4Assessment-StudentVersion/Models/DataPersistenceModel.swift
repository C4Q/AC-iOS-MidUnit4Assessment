//
//  DataPersistenceModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class DataPersistenceModel {
    
    static let kPathname = "PastCardGames.plist"
    
    private init() { }
    static let shared = DataPersistenceModel()
    
    private var pastGames = [PastGame]() {
        didSet {
            savePastGames()
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistenceModel.shared.documentsDirectory().appendingPathComponent(path)
    }
    
    private func savePastGames() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(pastGames)
            try data.write(to: dataFilePath(withPathName: DataPersistenceModel.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    public func load() {
        let path = dataFilePath(withPathName: DataPersistenceModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            pastGames = try decoder.decode([PastGame].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    public func addPastGame(pastGame item: PastGame) {
        pastGames.append(item)
    }
    
    public func getPastGames() -> [PastGame] {
        return pastGames
    }

    public func clearPastGames() {
        pastGames = []
    }
}
