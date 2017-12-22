//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    
    var cards: [[Card]] = [] {
        didSet {
            historyTableView.reloadData()
        }
    }
    
    var scores: [(score: Int, targetScore: Int)] = [] {
        didSet {
            historyTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scores = PersistentData.manager.getSavedScores()
        cards = PersistentData.manager.getSavedCardGames()
        
        historyTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cards = PersistentData.manager.getSavedCardGames()
        scores = PersistentData.manager.getSavedScores()
    }
    
    @IBAction func clearHistoryButtonPressed(_ sender: UIButton) {
        PersistentData.manager.removeCardGames()
        PersistentData.manager.removeScores()
        PersistentData.manager.removeTargetScores()
        
        cards = []
        scores = []
        
        let alertController = Alert.createAlertController(withTitle: "SUCCESS", andMessage: "Hmm... probably trying to get rid of your failures lol 😂\nThe deed is done 😂")
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let scoreInfo = scores[section]
        
        return "Score: \(scoreInfo.score) | Target Score: \(scoreInfo.targetScore)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        guard let historyCell = cell as? CollectionViewTableViewCell else {
            return cell
        }
        
        let currentCardGame = cards[indexPath.section]

        historyCell.setUpCollectionView(forCell: historyCell, withCards: currentCardGame)
        
        return historyCell
    }
    
}
