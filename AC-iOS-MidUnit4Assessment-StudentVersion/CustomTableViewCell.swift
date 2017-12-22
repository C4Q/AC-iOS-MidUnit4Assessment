//
//  CustomTableViewCell.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                
                layout.scrollDirection = .horizontal
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
                self.addSubview(collectionView)
            }
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return KeyedArchiverClient.shared.getHands()[KeyedArchiverClient.shared.currentTableViewIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let index = indexPath.item
        let card = KeyedArchiverClient.shared.getHands()[KeyedArchiverClient.shared.currentTableViewIndex][index]
        cell.backgroundView = {
//            let label = UILabel()
//            label.text = card.value.first?.description.capitalized
//            label.center = cell.center
//            label.textAlignment = .center
//            return label
            let imageView = UIImageView()
            imageView.sizeToFit()
            ImageDownloader.manager.getImage(from: card.image,
                                             completionHandler: {imageView.image = UIImage(data: $0); cell.setNeedsLayout()},
                                             errorHandler: {print($0)})
            imageView.center = self.center
            return imageView
        }()
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CardCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
