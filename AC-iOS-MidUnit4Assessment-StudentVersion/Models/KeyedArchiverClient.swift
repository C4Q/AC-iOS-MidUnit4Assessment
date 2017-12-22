//
//  KeyedArchiverClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
class KeyedArchiverClient {
    private init() {}
    // singleton
    static let manager = KeyedArchiverClient()
    private let pathName = "GameSaved.plist"
    private let defaults = UserDefaults.standard
    private let keyUser = "UserSetting"
    private var games = [Game]() {
        didSet{
            saveToDisk()
        }
    }
    
    func saveSetting(_ category: Int) {
        defaults.set(category, forKey: keyUser)
    }
    
    func getSetting() -> Int? {
        if let userIndex = defaults.value(forKey: keyUser) as? Int {
            return userIndex
        }
        return nil
    }
    
    // returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // /documents/Favorites.plist
    // returns the path for supplied name from the dcouments directory
    func dataFilePath(withPathName path: String) -> URL {
        return KeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(games)
            try data.write(to: dataFilePath(withPathName: KeyedArchiverClient.manager.pathName), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }
    
    // load from documents directory
    func load() {
        // where are we loading from????
        let path = dataFilePath(withPathName: KeyedArchiverClient.manager.pathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            games = try decoder.decode([Game].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    func saveGame(game: Game) {
        
        // save favorite object
        let newGame = Game.init(score: game.score, game: game.game)
        games.append(newGame)
    }
    
    // delete
    public func removeGameHistorial() {
        games = []
    }
    
    func getGameSaved() -> [Game] {
        return games
    }
}
