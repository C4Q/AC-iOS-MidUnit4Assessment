//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

class HistoryViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var historyCollectionView: UICollectionView!
	@IBOutlet weak var resetButton : UIButton!

	//MARK: View Overrrides
	override func viewWillAppear(_ animated: Bool) {
		print("HVC - In ViewWillAppear"); print()
		print("HVC - viewWillAppear - History (before Load) = \(history)"); print()
		loadHistory()
		print("HVC - viewWillAppear - History (after Load) = \(history)"); print()
		tableView.reloadData()
	}
	override func viewDidLoad() {
		print("HVC - In ViewDidLoad"); print()
		super.viewDidLoad()
		//TableView
			tableView.delegate = self
			tableView.dataSource = self
	}



	//MARK: Actions
	@IBAction func resetHistory(_ sender: UIButton) {
		print("HVC - in Action: resetHistory"); print()
		showResetHistoryAlert()
		tableView.reloadData()
//		historyCollectionView.reloadData()
	}

	//MARK: Properties
//	var history: [SavedGame] = []
	var history: [SavedGame] = DataModel.manager.getHistory()

	//MARK: Methods
	func loadHistory(){
		print("HVC - Methods - Load History"); print()
		history = DataModel.manager.getHistory()
		print("HVC - History (in loadHistory): \(history)"); print()
//		history.append(contentsOf: DataModel.manager.getHistory())
		if history.isEmpty {
			
		}
	}
	private func showResetHistoryAlert(){
		print("HVC - Methods - showResetHistoryAlert()"); print()
		let alertController = UIAlertController(title: "Reset History", message: "You are about to delete ALL History", preferredStyle: .alert)
		let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(okAlert)
		present(alertController, animated: true, completion: nil)
		print()
		print("HVC - showResetHistoryAlert - Delete History: \(DataModel.manager.deleteHistory())"); print()
		DataModel.manager.deleteHistory()
		print("HVC - in reset Alert - History(before delete): \(history)"); print()
		history = [SavedGame]()
		print("HVC - in reset Alert - History(after delete): \(history)"); print()
	}

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		print("HVC - TableView - numberOfSections"); print()
		print("HVC - TableView number of Sections - History count: \(history.count)"); print()
		if history.isEmpty { return 0}
		return history.count
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if history.isEmpty { return ""}
		print("HVC - TableView - titleForHeaderInSection"); print()
		print("HVC - TableView - Is history empty?: \(history.isEmpty)"); print()
		print("HVC - TableView - Section: \(section) Score: \(history[section].score)"); print()
		print("HVC - TableView -History[section]: \(history[section])"); print()
		return "Final Hand Value: \(history[section].score)"
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("HVC - TableView - numberOfRowsInSection"); print()
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("HVC - TableView - cellForRowAt"); print()
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SaveCardCell") as? GameRow else {return UITableViewCell(); print("ERROR in cellforAt"); print()}
		return cell
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		print("HVC - TableView - willDisplay"); print()
		guard let tableViewCell = cell as? TableViewCell else { print("HVC - TableView - Error in willDisplay"); print(); return }
		print("HVC -  TableView willDisplay tableViewCell: \(tableViewCell)"); print()
		tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
	}
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		print("HVC - TableView - didEndDisplaying"); print()
		guard let cell = cell as? TableViewCell else { print("HVC - TableView - Error in didEndDisplaying"); print(); return}
		cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
	}
}

//Collection View
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		print("HVC - CollectionView - numberOfSections"); print()
		print("HVC - History.count: \(history.count)"); print()
		return 1
//	return history.count
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print("HVC - CollectionView - numberOfItemsInSection"); print()
		print("HVC - numberOfItemInSection: \(history[collectionView.tag].cards.count)"); print()
		return history[collectionView.tag].cards.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		print("HVC - CollectionView - cellforItemAt"); print()
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCardCell", for: indexPath) as! CardCell
		print()
		print("HVC - CollectionView - cell: \(cell)"); print()
		let game = history[collectionView.tag]
		print()
		print("HVC - CollectionView - game: \(game)"); print()
		let gameCard = game.cards[indexPath.row]
		print("HVC - CollectionView - gameCard: \(gameCard)"); print()
		let gameCard2 = history[collectionView.tag].cards[indexPath.row]
		print("HVC - CollectionView - gameCard2: \(gameCard2)"); print()
		cell.valueLabel.text = "\(gameCard.cardValueInt)"
		print("HVC - CollectionView - gameCard2: \(gameCard.cardValueInt)"); print()
		cell.cardImage.image = gameCard.cardImage
		print("HVC - CollectionView - gameCard2: \(gameCard.cardImage)"); print()
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("HVC - CollectionView - didSelectItemAt"); print()
		print("HVC - Collection view at row \(collectionView.tag) selected index path \(indexPath)"); print()
	}
}

