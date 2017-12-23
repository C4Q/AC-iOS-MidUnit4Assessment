//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.

import Foundation
import UIKit

class HistoryViewController: UIViewController {

	//MARK: Outlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var resetButton : UIButton!

	//MARK: View Overrrides
	override func viewWillAppear(_ animated: Bool) {
		loadHistory()
		tableView.reloadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
	}

	//MARK: Actions
	@IBAction func resetHistory(_ sender: UIButton) {
		showResetHistoryAlert()
	}

	//MARK: Properties
	var history: [SavedGame] = DataModel.manager.getHistory()

	//MARK: Methods
	func loadHistory(){
		history = DataModel.manager.getHistory()
	}

	private func showResetHistoryAlert(){
		let alertController = UIAlertController(title: "Reset History", message: "You are about to delete ALL History", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Restart Game", style: .default) { (action:UIAlertAction!) in
			DataModel.manager.deleteHistory()
			self.history = [SavedGame]()
			self.tableView.reloadData()
		}
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if history.isEmpty { return 0}
		return history.count
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if history.isEmpty { return ""}
		return "Final Hand Value: \(history[section].score)"
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell") as? TableViewRow {
			cell.tableIndexPath = indexPath
			return cell
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 210
	}
}
