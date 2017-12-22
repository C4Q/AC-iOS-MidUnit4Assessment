//
//  NetworkHelper.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


class SavedHandsArchiverClient {
    private init() {}
    static let manager = SavedHandsArchiverClient()
    
    static let pathName = "SavedHands.plist"
    
    private var savedHandsArr = [[[Card]]]() {
        didSet {
            saveHands()
        }
    }
    
    func add(hand: [[Card]]) {
        savedHandsArr.append(hand)
    }
    
    func getHands() -> [[[Card]]] {
        return savedHandsArr
    }
    
    func loadHands() {
        let path = dataFilePath(withPathName: SavedHandsArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let hands = try PropertyListDecoder().decode([[[Card]]].self, from: data)
            self.savedHandsArr = hands
        }
        catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    func saveHands() {
        //encode into data so they can be saved with propertyListEncoder
        let path = dataFilePath(withPathName: SavedHandsArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(savedHandsArr)
            //write this data to a plist
            try data.write(to: path, options: .atomic)
            
        }
        catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    //returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        //this is finding the document folder in the app
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return document folder url path
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        //now you can write to the file/pathName you pass in! (If the file name doesn't exsist, it will create it)
        return SavedHandsArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
}



