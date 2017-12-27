//
//  CardHistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardHistoryViewController: UIViewController {
 
    var cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var favorites = [Favorite](){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.favorites = PersistentStoreManager.manager.getFavorites()
        tableView.reloadData()
    }
    
    
    
    @IBOutlet weak var resetHistoryButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favorites = PersistentStoreManager.manager.getFavorites()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        resetHistoryButton.layer.cornerRadius = resetHistoryButton.frame.width/2
    }
    
    


    @IBAction func resetHistoryPressed(_ sender: UIButton) {
        PersistentStoreManager.manager.resetFavorites()
       
        self.favorites.removeAll()
    }

}

extension CardHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardHistoryCell", for: indexPath) as! CardHistoryTableViewCell
        var favoriteToSelect = favorites[indexPath.row]
        cell.finalHandLabel.text = "Final Hand: " + favoriteToSelect.finalValue.description
        cell.configureCollectionView(forCell: cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}






