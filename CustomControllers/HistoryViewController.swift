//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noHistoryView: UIView!
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    var cellSpacing: CGFloat {
        if screenHeight > screenWidth { return screenHeight * 0.05}
        return screenWidth * 0.05
    }
    var storedOffsets = [Int: CGFloat]() // provided online
    
    var pastGames = [PastGame]() {
        didSet {
            noHistoryView.isHidden = !pastGames.isEmpty
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        pastGames = PersistenceStoreManager.manager.getPastGames()
    }
    
    @IBAction func resetHistory(_ sender: UIButton) {
        let _ = PersistenceStoreManager.manager.deleteAllGames()
        pastGames = PersistenceStoreManager.manager.getPastGames()
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastGames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let shorterOfTwo = (screenHeight > screenWidth ? screenWidth : screenHeight)
        return shorterOfTwo * 0.6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let game = pastGames[indexPath.row]
        
        cell.backgroundColor = UIColor.green
        cell.finalValue.text = "Final Hand Value: \(game.finalVal)"
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HistoryTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HistoryTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numCells: CGFloat = 0
        let numSpaces: CGFloat = 2
        let shorterOfTwo = (screenHeight > screenWidth ? screenWidth : screenHeight)
        if screenHeight > screenWidth {
            numCells = 1.5
        }
        else {
            numCells = 1.5
        }
        return CGSize(width: (shorterOfTwo - (numSpaces * cellSpacing)) / numCells, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
}



// https://ashfurrow.com/blog/putting-a-uicollectionview-in-a-uitableviewcell-in-swift/
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastGames[collectionView.tag].cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        
        let card = pastGames[collectionView.tag].cards[indexPath.row]
        
        cell.backgroundColor = UIColor.green
        cell.cardValue.text = card.value
        cell.cardImage.image = #imageLiteral(resourceName: "Tutr2")
        configureCell(withCard: card, forCell: cell)
        return cell
    }
    
    private func configureCell(withCard card: Card, forCell cell: CardCollectionViewCell) {
        
        // if we have the image in cache then set the image to the cell
        if let image = ImageCache.manager.cachedImage(url: card.image) {
            cell.cardImage.image = image
        } else { // we don't have an image for the cell in cache, let's process on background
            
            // keep track of cell that was set
            cell.urlString = card.image.absoluteString
            
            ImageCache.manager.processImageInBackground(imageURL: card.image, completion: { (error, image) in
                if let error = error {
                    // handle error
                    print("error: \(error.localizedDescription)")
                } else if let image = image {
                    
                    // set the cell if the url string matches
                    
                    // cells are being dequeued and reprocessed at this point
                    if cell.urlString == card.image.absoluteString {
                        DispatchQueue.main.async {
                            cell.cardImage.image = image
                            cell.urlString = card.image.absoluteString
                        }
                    }
                }
            })
        }
        
    }
}
