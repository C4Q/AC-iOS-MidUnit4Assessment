//
//  Persistent Store Manager.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


class PersistentStoreManager {

    static let kPathname = "Favorites.plist"
    private init(){}
    static let manager = PersistentStoreManager()

    private var favorites = [Favorite]() {
        didSet{
            saveToDisk()
        }
    }



    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }





    func dataFilePath(withPathName path: String) -> URL {
        return PersistentStoreManager.manager.documentsDirectory().appendingPathComponent(path)
    }



    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: PersistentStoreManager.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }








    func load() {
        let path = dataFilePath(withPathName: PersistentStoreManager.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }








    func addToFavorites(cards: [Card], finalValue: Int, id: String) -> Bool  {


        let indexExist = favorites.index{ $0.idDeck == id}
//        if indexExist != nil { print("FAVORITE EXIST"); return false }

        let newFavorite = Favorite.init(cards: cards, idDeck: id, finalValue: finalValue)
        favorites.append(newFavorite)
        return true
    }








    func getFavorites() -> [Favorite] {
        load()
        return favorites
    }



    func resetFavorites(){
        favorites.removeAll()
    }

    func removeFavorite(andfavorite favorite: Favorite) -> Bool {
     
        let favoriteURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(favorite.idDeck)")
        do {
            try FileManager.default.removeItem(at: favoriteURL)
            print("\n==============================================================================")
            print("\(favoriteURL) removed")
            print("==============================================================================\n")
            return true
        } catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }

}

