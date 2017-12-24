//  DataModel.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by Winston Maragh on 12/22/17.
//  Copyright © 2017 Winston Maragh. All rights reserved.

import Foundation
import UIKit

class DataModel {
	//MARK: FileName
	static let kPathName = "History.plist"

	//Singleton
	private init(){}
	static let manager = DataModel()

	//MARK: Variables
	private var history = [SavedGame]() {
		didSet {
			saveHistory()
		}
	}

	//MARK: Methods
	//returns Documents directory path for the App
	func documentDirectory()->URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0] //the 0 is the document folder

	}

	//returns supplied path name in documents directory
	func dataFilePath(pathName: String)->URL {
		return DataModel.manager.documentDirectory().appendingPathComponent(pathName)
	}

	//Load (decode)
	func loadHistory(){
		let path = dataFilePath(pathName: DataModel.kPathName)
		do {
			let data = try Data.init(contentsOf: path)
			history = try PropertyListDecoder().decode([SavedGame].self, from: data)
		} catch {print("decoder error: \(error.localizedDescription)")}
	}

	//Save (encode)
	func saveHistory(){
		do {
			let data = try PropertyListEncoder().encode(history)
			try data.write(to: dataFilePath(pathName: DataModel.kPathName), options: .atomic)
		}
		catch {print("encoder error: \(error.localizedDescription)")}
		print(documentDirectory())

	}

	//Read (get)
	func getHistory() -> [SavedGame]{
		return history
	}

	//Add
	func addGameToHistory(game: SavedGame) {
		history.append(game)
	}

	//Delete game from History
	func deleteGameFromHistory(fromIndex index: Int){
		history.remove(at: index)
	}

	func deleteHistory() {
		history.removeAll()
	}
}


