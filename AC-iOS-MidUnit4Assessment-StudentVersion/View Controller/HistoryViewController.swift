//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    //Mark: - Outlets
     let cellSpacing: CGFloat = 20.0 //creating constant for the cell spacing
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var resetHistoryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func ResetHistoryButtonPressed(_ sender: UIButton) {
        //delete from userDefualts and File Manager
    }
    
    
}

//MARK: - TableView Set-up
extension  HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 75 //cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

//MARK: - CollectionView Set-up
extension  HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    //returns how large the cells should be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 9//number of cells visible in row
        let numSpace: CGFloat = numCells + 5.5
        let screenWidth = UIScreen.main.bounds.width  // screen width fo the device
        //print("cells are large enough!")
        //cgsize expects a tuple: (width, height)
        //returns item size
        return CGSize(width:(screenWidth-(cellSpacing * numSpace)), height: collectionView.bounds.height - (cellSpacing * 2))
        //return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
    }
    
    //returns padding around the collection view cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: cellSpacing, right: 0)
    }
    
    //returns padding between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}


