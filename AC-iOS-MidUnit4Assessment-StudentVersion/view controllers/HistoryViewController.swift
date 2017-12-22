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
    
    var pastHands = Persistence.manager.getHands()
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Persistence.manager.loadHand()

    }

   
    //TODO reset history Button Action 

}
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastHands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
    
    
    
    
    
    
}
