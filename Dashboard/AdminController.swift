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
    
    
    // values für die Header Höhe
    var headings = [120]
    
    let cellId = "cellId"
    var host = "192.168.101.1"
    var port = 8080
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
    }
    
    
    // Funktion prüft ob die App zum ersten Mal gestartet wurde,
    // und setzt dann default Werte für host und port,
    // ansonsten läd sie die gespeicherten Werte
    override func viewWillAppear(_ animated: Bool) {
        
        let firstlaunch = UserDefaults.isFirstLaunch()
        
        if firstlaunch {

            UserDefaults.standard.set(host, forKey: "host")
            UserDefaults.standard.set(port, forKey: "port")
            
        } else {

            if let ip = UserDefaults.standard.value(forKey: "host"),
                let po = UserDefaults.standard.value(forKey: "port") {
                
                host = ip as! String
                port = po as! Int
            }
        }
        tableView.reloadData()
    }
    
    // Funktion versteckt die Tastatur wenn der User ausserhalb der Eingabefläche klickt
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // Funktion zum anzeigen eines Alarm mit individuellem Text
    func promptUserWith(text: String) {
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(title: "Achtung", contentText: text, actions: [okAction])
    }
    
    
    // Funktion speichert alle Eingaben des Users und zeigt einen Alarm an,
    // wenn Daten falsch eingegeben wurden, oder alles gespeichert wurde.
    func saveIpPort() {
        
        if portTextfield.text!.isEmpty && ipTextfield.text!.isEmpty {
            
            promptUserWith(text: "Bitte füllen Sie alle Felder korrekt aus.")
            
        } else {
            
            UserDefaults.standard.set(ipTextfield.text, forKey: "host")
            UserDefaults.standard.set(Int(portTextfield.text!), forKey: "port")
            
            host = ipTextfield.text!
            port = Int(portTextfield.text!)!
            
            tableView.reloadData()
            
            view.endEditing(true)
            
            promptUserWith(text: "IP und Port wurden geändert.")
        }
    }
    
    
    // ---- SETUP VIEWS ----
    
    func setupHeaderview() {

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Einstellungen"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(headerView)
        headerView.addSubview(label)
        headerView.addSubview(ipAddressLabel)
        headerView.addSubview(ipTextfield)
        headerView.addSubview(portLabel)
        headerView.addSubview(portTextfield)
        headerView.addSubview(saveButton)
        
        headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        label.bottomAnchor.constraint(equalTo: headerView.topAnchor, constant: 60).isActive = true
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 48).isActive = true
        
        ipAddressLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 70).isActive = true
        ipAddressLabel.leftAnchor.constraint(equalTo: label.leftAnchor).isActive = true
        
        ipTextfield.centerYAnchor.constraint(equalTo: ipAddressLabel.centerYAnchor).isActive = true
        ipTextfield.leftAnchor.constraint(equalTo: ipAddressLabel.rightAnchor, constant: 15).isActive = true
        ipTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        ipTextfield.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        portLabel.centerYAnchor.constraint(equalTo: ipTextfield.centerYAnchor).isActive = true
        portLabel.leftAnchor.constraint(equalTo: ipTextfield.rightAnchor, constant: 15).isActive = true
        
        portTextfield.topAnchor.constraint(equalTo: ipTextfield.topAnchor).isActive = true
        portTextfield.leftAnchor.constraint(equalTo: portLabel.rightAnchor, constant: 15).isActive = true
        portTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        portTextfield.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        saveButton.centerYAnchor.constraint(equalTo: portTextfield.centerYAnchor).isActive = true
        saveButton.leftAnchor.constraint(equalTo: portTextfield.rightAnchor, constant: 20).isActive = true
        
    }
    
    // ---- VIEWS -----
    
    var ipAddressLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "IP Addresse"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var portLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Port"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var ipTextfield: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.placeholder = "z. B. 192.168.101.1"
        tf.layer.cornerRadius = 4
        tf.keyboardType = .decimalPad
        tf.autocapitalizationType = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = UITextFieldViewMode.always
        return tf
    }()
    
    var portTextfield: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tf.placeholder = "z. B. 8080"
        tf.layer.cornerRadius = 4
        tf.keyboardType = .numberPad
        tf.autocapitalizationType = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = UITextFieldViewMode.always
        return tf
    }()
    
    var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Speichern", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(saveIpPort), for: .touchUpInside)
        return button
    }()
    
    // ------ Delegates -----
    
    // Funktion gibt den View für den Header zurück
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        setupHeaderview()
        
        return headerView
    }
    
    // Funktion gibt die Höhe der Cells zurück
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    // Funktion gibt die Cell zurück und legt fest was in der Cell angezeigt wird
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        
        
        switch (indexPath.row) {
        case (0):
            cell.detailTextLabel?.text = "1.0"
        case (1):
            cell.detailTextLabel?.text = "Philipp Tschauner"
        case (2):
            cell.detailTextLabel?.text = host
        case (3):
            cell.detailTextLabel?.text = "\(String(describing: port))"
            
        default: break
            
        }
        
        return cell
    }
    
    // Funktion gibt die Anzahl der Objekte im CollectionView zurück
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    // Funktion gibt die Höhe des HeaderViews zurück
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    // Funktion bestimmt was passiert wenn man eine Cell klickt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
