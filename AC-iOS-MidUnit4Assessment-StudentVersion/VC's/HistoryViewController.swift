//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var noSavedHandsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func resetSavedGamesButton(_ sender: UIButton) {
        SavedHandsArchiverClient.manager.eraseSaves()
    }
    
    var savedHands = [[[Card]]]() {
        didSet {
            if savedHands.isEmpty {
                noSavedHandsLabel.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        
    }
    
    func loadData() {
        //Load the data saved on the phone
        SavedHandsArchiverClient.manager.loadHands()
        self.savedHands = SavedHandsArchiverClient.manager.getHands()
    }
}
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedHands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thisTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! HandTableViewCell
        thisTableViewCell.savedHands = self.savedHands
        thisTableViewCell.configureCollectionView(forCell: thisTableViewCell, forIndexPath: indexPath)
        
        return thisTableViewCell
    }
}


extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
