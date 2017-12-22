//
//  ViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q  on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BlackJackViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var currentHandValueLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func drawACardButtonPressed(_ sender: UIButton) {
    }
    
    let cellSpacing: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardCollectionView.dataSource = self
        self.cardCollectionView.delegate = self
        //Setting my nib
//        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
//        self.cardCollectionView.register(nib, forCellReuseIdentifier: "Pixabay Cell")
    }
}

extension BlackJackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10//bestSellerBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as? CardsCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = #imageLiteral(resourceName: "puppy")
        cell.cardValueLabel.text = "10"
        //let chosenBestSellerBook = bestSellerBooks[indexPath.item]
        //cell.weeksAsBestSellerLabel.text = "\(chosenBestSellerBook.weeksOnBestSellerList) weeks on best seller list"
        //cell.shortDescriptionLabel.text = chosenBestSellerBook.bookDetails.description
        //SET IMAGE
        //TODO: Get the thumbnail url ...let imageStr = googleBook.volum...
        //TODO: Call the imageAPIClient & set completion like this...completion handler {cell.bookiangeView.image = $0}
        return cell
    }
}
//To customize my cell & set the delegate
extension BlackJackViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 2.0 // cells visible in row
        let numSpaces: CGFloat = numCells + 1
        let screenWidth = UIScreen.main.bounds.width // screen width of device
        
        // retrun item size
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: collectionView.bounds.height - (cellSpacing * 2))
    }
    
    // padding around our collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    // padding between cells / items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}









//example code for a call
//func loadImage(named str: String) {
//    PixabayAPIClient.manager.getFirstImage(named: str, completionHandler: {self.pixabay = $0}, errorHandler: {print($0)})
//}

//func loadCategories() {
//    let loadData: ([Categories]) -> Void = {(onlineCategory: [Categories]) in
//        self.categories = onlineCategory
//    }
//    let url = BookCategoriesAPIClient.urlStr
//    BookCategoriesAPIClient.manager.getCategories(with: url,completionHandler: loadData, errorHandler: {print($0)})
//}

