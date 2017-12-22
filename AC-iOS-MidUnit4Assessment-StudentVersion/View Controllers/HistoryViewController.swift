////  HistoryViewController.swift
////  AC-iOS-MidUnit4Assessment-StudentVersion
////  Created by C4Q on 12/22/17.
////  Copyright © 2017 C4Q . All rights reserved.
//
//import UIKit
//
//class HistoryViewController: UIViewController {
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		loadsavedGamesHistory()
//
//	}
//
////	var savedGamesHistory: [[SavedGames]]
//
//
//	func loadsavedGamesHistory(){
//
//	}
//
//}
//
//extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return savedGamesHistory.count
//	}
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//		return cell
//	}
//	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//		guard let tableViewCell = cell as? TableViewCell else { return }
//		tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//	}
//	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//		guard let tableViewCell = cell as? TableViewCell else { return }
//	}
//}
//
////Collection View
//extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return savedGamesHistory[collectionView.tag].count
//	}
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
////		cell. = savedGamesHistory[collectionView.tag][indexPath.item]
//		return cell
//	}
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
//	}
//}

