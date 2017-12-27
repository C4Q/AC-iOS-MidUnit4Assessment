//
//  GamesSavedViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GamesSavedViewController: UIViewController {

    @IBOutlet weak var gamesSavedTableView: UITableView!
    
    var gameSaved = [Game]() {
        didSet {
            self.gamesSavedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gamesSavedTableView.delegate = self
        self.gamesSavedTableView.dataSource = self
        KeyedArchiverClient.manager.load()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.gameSaved = KeyedArchiverClient.manager.getGameSaved()
    }
    
    
    @IBAction func clearHistoryButton(_ sender: UIButton) {
        KeyedArchiverClient.manager.removeGameHistorial()
        self.gameSaved = KeyedArchiverClient.manager.getGameSaved()
        let alert = UIAlertController(title: "Historial", message: "Historial has beend cleaned", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
