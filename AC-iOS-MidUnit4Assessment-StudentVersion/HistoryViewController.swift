//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    var cardsArr: [[Card]] {
        return PersistentStoreManager.manager.getHistory()
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.tableView.delegate = self
        self.tableView.dataSource = self
        
       self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        PersistentStoreManager.manager.resetHistory()
        self.tableView.reloadData()
    }
    
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cardsArr.count
        return PersistentStoreManager.manager.getTotalValue().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "history cell", for: indexPath) as! HistoryTableViewCell
        cell.cards = cardsArr[indexPath.row]
        let value = PersistentStoreManager.manager.getTotalValue()[indexPath.row]
        cell.totalValueLabel.text = "Final Hand Value: \(value)"
        cell.collectionView.reloadData()
        return cell
    }
}
