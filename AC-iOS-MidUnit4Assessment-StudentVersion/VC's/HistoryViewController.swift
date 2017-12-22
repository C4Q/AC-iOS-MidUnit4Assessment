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
    
//    var savedHands = [Card]() {
//        didSet {
//            if savedHands.isEmpty {
//                noSavedHandsLabel.isHidden = true
//            }
//        }
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
