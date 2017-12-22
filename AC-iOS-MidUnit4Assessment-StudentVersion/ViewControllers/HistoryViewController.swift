//
//  HistoryViewController.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Masai Young on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {


    @IBAction func resetHistoryPressed(_ sender: UIButton) {
        KeyedArchiverClient.shared.resetHistory()
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

// MARK: Table View Data Source
extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if KeyedArchiverClient.shared.getHands().isEmpty {
            tableView.backgroundView = {
                let label = UILabel()
                label.text = "You have no favorites!"
                label.center = tableView.center
                label.textAlignment = .center
                tableView.separatorStyle = .none
                return label
            }()
            return 0
        } else {
            tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeyedArchiverClient.shared.getHands().count
    }
    
    // MARK: - Cell Rendering
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! CustomTableViewCell
        KeyedArchiverClient.shared.currentTableViewIndex = indexPath.row
        return cell
    }
    
}

// MARK: Table View Delegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
