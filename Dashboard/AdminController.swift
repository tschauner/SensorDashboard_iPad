//
//  AdminController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 18.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class AdminController: UITableViewController {
    
    
    var values = ["Version", "Autor", "IP Adresse", "Port"]
    
    
    // values for header heights
    var headings = [120]
    
    let cellId = "cellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }
    
    func updateHost() {
        
    }
    
    func updatePort() {
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Einstellungen"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        headerView.addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -40).isActive = true
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 48).isActive = true
        
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        
        
        switch (indexPath.row) {
        case (0):
            cell.detailTextLabel?.text = "1.01"
        case (1):
            cell.detailTextLabel?.text = "Philipp Tschauner"
        case (2):
            cell.detailTextLabel?.text = "192.168.101.1"
        case (3):
            cell.detailTextLabel?.text = "8080"
            
        default: break
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    
}
