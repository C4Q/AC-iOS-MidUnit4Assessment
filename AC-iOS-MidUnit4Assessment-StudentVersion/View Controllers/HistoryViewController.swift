//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import UIKit

class HistoryViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var historyCollectionView: UICollectionView!
	@IBOutlet weak var resetButton : UIButton!

	//MARK: View Overrrides
	override func viewDidLoad() {
		super.viewDidLoad()

		//TableView
		tableView.delegate = self
		tableView.dataSource = self

		//CollectionView
		self.historyCollectionView.delegate = self
		self.historyCollectionView.dataSource = self

		loadHistory()
	}


	//MARK: Actions
	@IBAction func resetHistory(_ sender: UIButton) {
		DataModel.manager.deleteHistory()
	}


	//MARK: Properties
	var history: [SavedGame] = []


	//MARK: Methods
	func loadHistory(){
		history = DataModel.manager.getHistory()
	}
	private func showResetHistoryAlert(){
		let alertController = UIAlertController(title: "Reset History", message: "You are about to delete ALL History", preferredStyle: .alert)
		let okAlert = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(okAlert)
		present(alertController, animated: true, completion: nil)
	}

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return history.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		return cell
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard let tableViewCell = cell as? TableViewCell else { return }
		tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
	}
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard cell is TableViewCell else { return }
	}
}

//Collection View
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return history.count
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return history[collectionView.tag].cards.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
		let game = history[collectionView.tag]
		let gameCard = game.cards[indexPath.row]
		configureCard(card: gameCard, forCell: cell)
		return cell
	}
	func configureCard(card: Card, forCell cell: CardCell) {
		DispatchQueue.global().async {
			do {
				let imageData = try Data.init(contentsOf: URL(string: card.image)!)
				DispatchQueue.main.async {
					cell.cardImage.image = UIImage.init(data: imageData)
				}
			} catch {print("image processing error: \(error.localizedDescription)")}
		}
		//		//Image processing for cell
		//		let imageURL = card.image //image url source
		//		let setImage: (UIImage)-> Void = {(onlineImage: UIImage) in
		//			cell.cardImage?.image = onlineImage
		//			cell.setNeedsLayout()
		//		}
		//		ImageHelper.manager.getImage(from: imageURL, completionHandler: setImage, errorHandler: {print($0)})
	}


	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
	}
}

