//  SavedGames.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

struct SavedGames: Codable {
	let title: String
	let year: String
	let imdbId: String
	let type: String
	let poster: URL
	// optional keys
	let plot: String?

	// computed property to return image from documents
	var image: UIImage? {
		set{}
		get {
			let imageURL = MovieDataStore.manager.dataFilePath(withPathName: imdbId)
			let docImage = UIImage(contentsOfFile: imageURL.path)
			return docImage
		}
	}
}
