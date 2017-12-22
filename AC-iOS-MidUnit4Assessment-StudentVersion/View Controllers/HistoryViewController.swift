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
    
    //data source variable should maybe be an array of tuples? (actual score, target score) - ex: (29/30)
    //this should be kept track of when getting the cards
    // there should be two arrays: - (current score, target score), and [actual cards] - different arrays for header and table view
//    var cards: [[Card]] = [] // to do
    //for each collection view
    
    var scores: [(actualScore: Int, targetScore: Int)] = [] //for each header
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //should load
        
        historyTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //update scores and cards
        //then reload tableview
    }
    
    @IBAction func clearHistoryButtonPressed(_ sender: UIButton) {
        //to do
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //to do - should return the number of card games
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        // to do
        //should configure cell by passing in the data source variable
        
        return cell
    }
    
}
