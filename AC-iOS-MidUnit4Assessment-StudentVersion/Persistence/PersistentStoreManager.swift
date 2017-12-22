//
//  PersistentStoreManager.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
class RecentsDataStore {
    
    static let kPathname = "Recents.plist"
    
    // singleton
    private init(){}
    static let manager = RecentsDataStore()
    
    private var recents = [Recents]() {
        didSet{
            saveToDisk()
        }
    }
    
    // returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // returns the path for supplied name from the dcouments directory
    func dataFilePath(withPathName path: String) -> URL {
        return RecentsDataStore.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    // write to path: /Documents/
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(recents)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: RecentsDataStore.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print(documentsDirectory())
        print("===================================================\n")
    }
    
    // load from documents directory
    func load() {
        // what's the path we are reading from?
        let path = dataFilePath(withPathName: RecentsDataStore.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            recents = try decoder.decode([Recents].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    // does 2 tasks:
    // 1. stores image in documents folder
    // 2. appends favorite item to array
    func addDataToRecents() -> Bool  {

        return true
    }
    
    // store image
    func storeDataToDisk() -> Bool {

        return true
    }
    

    func removeRecent(fromIndex index: Int) -> Bool {
        recents.remove(at: index)
            return false
        }
    }
    

