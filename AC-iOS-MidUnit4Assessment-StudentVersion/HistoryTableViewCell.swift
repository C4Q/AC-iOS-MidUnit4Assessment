//
//  HistoryTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/24/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
  var cards = [Card]()
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil )
        collectionView.register(nib, forCellWithReuseIdentifier: "cardCell")
       self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension HistoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        cell.imageView.image = nil
        var value = cards[indexPath.row].value
        if ["jack", "queen", "king"].contains(value.lowercased()) {
            value = "10"
        }
        cell.label.text = "\(value)"
        let imageURL = cards[indexPath.row].image
        ImageAPIClient.manager.getImages(from: imageURL, completionHandler: {cell.imageView.image = $0}, errorHandler: {print($0)})
        
        return cell
    }
}

