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
    
   let cellSpacing = UIScreen.main.bounds.size.width * 0.04
        
    var pastHands = [DataPersistence.Hand]() {
        didSet {
            historyTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyTableView.dataSource = self
        self.historyTableView.delegate = self
        DataPersistence.manager.loadHands()
        pastHands = DataPersistence.manager.getHands()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataPersistence.manager.loadHands()
        pastHands = DataPersistence.manager.getHands()
    }
   
    //TODO reset history Button Action 
}
extension HistoryViewController: UITableViewDelegate,UITableViewDataSource {


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pastHands.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
    
    if let cell = cell as? HistoryTableViewCell {
        
        cell.finalHandValueLabel.text = "Hand Total: " + pastHands[indexPath.row].handTotal.description

        
      
        let nib = UINib(nibName: "cardCell", bundle: nil)
        cell.pastHandCollectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
        
      
        cell.pastHandCollectionView.tag = indexPath.row
        

        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
    }
    
    cell.setNeedsLayout()
    
    return cell
}

func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    guard let tableViewCell = cell as? HistoryTableViewCell else { return }
    
    tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
}


}


extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastHands[collectionView.tag].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
        

        if let cell = cell as? cardCell {
            
            let card = pastHands[collectionView.tag].cards[indexPath.item]
            
            cell.configureCell(with: card)

            
        }
        return cell
    }
    
}

