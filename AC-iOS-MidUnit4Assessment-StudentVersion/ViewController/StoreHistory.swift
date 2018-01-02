//
//  StoreHistory.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/30/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class HistoryStoreData {
    static let kPathname = "GameHistory.plist"

    //singleton
    private init(){}
    static let manager = HistoryStoreData()

    private var history = [HistoryInfo]() {
        didSet {
            saveToDisk()
        }
    }

    //returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // /documents/Favorites.plist
    //returns the path for supplied name from the documents directory
    func dataFilePath(withPathName path: String) -> URL {
        return HistoryStoreData.manager.documentsDirectory().appendingPathComponent(path)
    }

    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(history)
            //does the writing to disk
            try data.write(to: dataFilePath(withPathName: HistoryStoreData.kPathname), options: .atomic)

            print("save History.plist:\(documentsDirectory())")
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    //load
    public func load() {
        let path = dataFilePath(withPathName: HistoryStoreData.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
           history = try decoder.decode([HistoryInfo].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
//
    //does 2 tasks:
    //1. stores image in documents folder
    //2. appends history item to array
    func addToHistory(card: Card, andImage image: UIImage) -> Bool {
        let indexExist = history.index{ $0.code == card.code  }

        if indexExist != nil {print("FAVORITE EXIST"); return false}
//
//
        // 1) save image from history photo
        let success = storeImageToDisk(image: image, andCard : card)
        if !success { return false }
        // 2) save favorite object
       
       
        let newHistory = HistoryInfo.init(value: card.value, code: card.code)
        history.append(newHistory)
        return true
    }
//
    func storeImageToDisk(image: UIImage, andCard card: Card) -> Bool {
        // packing data from image UIImagePNGrEPRESENTATION stores it as a PNG Image
        guard let imageData = UIImagePNGRepresentation(image) else {return false}
        // writing and saving to documents folder
        // 1) save image from history photo

       

        let imageURL = HistoryStoreData.manager.dataFilePath(withPathName: card.code)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }

//
    func getImage(identifier: String) -> UIImage? {
        let imageURL = HistoryStoreData.manager.dataFilePath(withPathName: identifier)
        do {
            let data = try Data.init(contentsOf: imageURL)
            let image = UIImage.init(data: data)
            return image
        } catch {
            print("getting Image error: \(error.localizedDescription)")
        }
        return nil
    }

    func getHistoryWithId(identifier: String) -> HistoryInfo? {
        let index = getHistories().index{$0.code == identifier }
        guard let indexFound = index else { return nil }
        return history[indexFound]
    }

    func getHistories() -> [HistoryInfo] {
        return history
    }

//    func removeFavorite(fromIndex index: Int, andBookImage favorite: Favorite) -> Bool {
//        favorites.remove(at: index)
//        // remove image
//        let imageURL = BookDataStore.manager.dataFilePath(withPathName: favorite.identifier)
//        do {
//            try FileManager.default.removeItem(at: imageURL)
//            print("\n==============================================================================")
//            print("\(imageURL) removed")
//            print("==============================================================================\n")
//            return true
//        } catch {
//            print("error removing: \(error.localizedDescription)")
//            return false
//        }
//    }


}
