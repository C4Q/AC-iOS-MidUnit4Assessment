//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/25/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  let cellSpacing = UIScreen.main.bounds.size.width * 0.05

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self

    }
    
    var history = [HistoryInfo]()

    
    
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            tableView.reloadData()
        }

}



extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! CustomTableViewCell
        let nib = UINib(nibName: "CollectionViewCell1", bundle: nil)
        cell.historyCollectionView.register(nib, forCellWithReuseIdentifier: "nibCell")
        cell.historyCollectionView.dataSource = self
        cell.historyCollectionView.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nibCell", for: indexPath) as! CollectionViewCell1
        let history = HistoryStoreData.manager.getHistories()[indexPath.row]
        guard let image = HistoryStoreData.manager.getImage(identifier: history.code) else {
            cell.cellImage.image = #imageLiteral(resourceName: "Image")
            return cell}
        cell.cellImage.image = image
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HistoryStoreData.manager.getHistories().count
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

}

