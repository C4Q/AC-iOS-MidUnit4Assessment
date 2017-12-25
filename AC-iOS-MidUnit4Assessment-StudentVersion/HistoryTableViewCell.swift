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
   let cellSpacing: CGFloat = 8.0
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
        } else if value.lowercased() == "ace" {
            value = "11"
        }
        cell.label.text = "\(value)"
        let imageURL = cards[indexPath.row].image
        ImageAPIClient.manager.getImages(from: imageURL, completionHandler: {cell.imageView.image = $0; cell.spinner.isHidden = true}, errorHandler: {print($0)})
        
        return cell
    }
}

extension HistoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCell: CGFloat = 3
        let numSpacing: CGFloat = numCell + 1
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: (screenWidth - (numSpacing * cellSpacing)) / numCell, height: screenHeight * 0.18)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: cellSpacing, bottom: 0, right: cellSpacing) // EdgeInset is top, left, bottom, right spacing of cell to the section edge.
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

