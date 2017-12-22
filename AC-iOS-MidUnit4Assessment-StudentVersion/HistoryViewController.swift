//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Reiaz Gafar on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Spacing for the collection view
    let spacing = UIScreen.main.bounds.size.width * 0.0125
    
    // Array of saved hands
    var hands = [DataPersistenceHelper.Hand]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if hands.isEmpty {
            alertController(title: "No Saved Data", message: "Play some Blackjack!")
        }
    }
    
    // Load and retrieve saved hands in view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataPersistenceHelper.manager.loadHands()
        hands = DataPersistenceHelper.manager.getHands()
    }
    
    // MARK: - Button
    // Reset button tap deletes saved hands
    @IBAction func resetHistoryButtonTapped(_ sender: UIButton) {
        DataPersistenceHelper.manager.deleteHands()
        hands = DataPersistenceHelper.manager.getHands()
    }
    
    
}

// MARK: - Helper Functions

extension HistoryViewController {
    
    func alertController(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - TableView
extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hands.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hand Value: " + hands[section].handTotal.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Target: " + hands[section].target.description
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        if let cell = cell as? HistoryTableViewCell {
            
            let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
            cell.collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
            
            
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            
            
            
            
            
            
        }
        
        
        
        return cell
    }
    
}

extension HistoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hands[collectionView.tag].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        if let cell = cell as? CardCollectionViewCell {
            
            let card = hands[collectionView.tag].cards[indexPath.row]
            
            cell.cardImageView.image = nil
            
            let cardImgUrl = card.image
            
            ImageHelper.manager.getImage(from: cardImgUrl, completionHandler: { cell.cardImageView.image = $0 }, errorHandler: { print($0) } )
            
//            if let brain = brain, let value = brain.cardValues[card.value] {
//                cell.cardLabel.text = value.description
//            }
            
            cell.cardLabel.text = card.value.description
            
        }
        
        return cell
    }
    
    
}

extension HistoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Define amount of cells I want per row
        let numCells: CGFloat = 3
        // Calculate the number of spaces I need to account for
        let numSpaces: CGFloat = numCells + 1
        // Return a CGSize to allow for a 4 by 1 view of cells
        return CGSize(width: ((collectionView.bounds.width - (spacing * numSpaces))/numCells), height: ((collectionView.bounds.height - (spacing * 2))))
    }
    
    // Set spacings to defined spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
}
