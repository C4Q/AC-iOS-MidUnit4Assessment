//
//  GameViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    let cardValues: [String:Int] = ["KING":13,
                                    "QUEEN":12,
                                    "JACK": 11,
                                    "10":10,
                                    "9":9,
                                    "8":8,
                                    "7":7,
                                    "6":6,
                                    "5":5,
                                    "4":4,
                                    "3":3,
                                    "2":2,
                                    "1":1]
    
    @IBOutlet weak var currentHandValueLabel: UILabel!
    
    @IBAction func stopButton(_ sender: UIButton) {
    }
    @IBAction func drawACard(_ sender: UIButton) {
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}
