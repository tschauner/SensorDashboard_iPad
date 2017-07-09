//
//  FindSensorController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit
import CoreLocation

class SensorLibraryController: UICollectionViewController {
    

    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        
        setupCollectionView()
        
        setupHeaderView()
        
        //Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(findBeaconInCell), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    // setup collection view
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.itemSize = CGSize(width: 180, height: 150)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(SensorLibraryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    
     // Find the same beacons in the table. - works only for one, but displays all available at the same time
//    @objc func findBeaconInCell() {
//
//        var b: CLBeacon?
//
//        var indexPaths = [IndexPath]()
//        for beacon in HomeController.allBeacons {
//            b = beacon
//            for row in 0..<Constants.devices.count {
//                if Constants.devices[row].minorValue == beacon.minor.intValue {
//                    indexPaths += [IndexPath(row: row, section: 0)]
//                }
//            }
//        }
//
//        // Update beacon locations of visible rows.
//        if let visibleRows = collectionView?.indexPathsForVisibleItems {
//            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
//            for row in rowsToUpdate {
//                let cell = collectionView?.cellForItem(at: row) as! SensorLibraryCell
//                guard let beacon = b else { return }
//                cell.updateDistance(HomeController.allBeacons[0].proximity, beacon: beacon)
//            }
//        }
//    }
    
    func showAddSensorController() {
        
        let addSensor = AddSensorController()
        
        navigationController?.pushViewController(addSensor, animated: true)
        //        present(nav, animated: true, completion: nil)
    }
    
    func showSensorDetailViewController(with device: DeviceModel) {
        
        let sensorDetail = SensorDetailViewController()
        sensorDetail.device = device
        
        navigationController?.pushViewController(sensorDetail, animated: true)
        
    }
    
    func showORScanner() {
        
        let qrcode = ScannerController()
        
        present(qrcode, animated: true, completion: nil)
    }
    
    
    func dismissView() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // prompts alert sheet with options
    func showOptions() {
        
        let noAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        let qrAction = UIAlertAction(title: "QR Code scannen", style: .default) { (action) in
            
            self.showORScanner()
        }
        
        let beaconAction = UIAlertAction(title: "iBeacon anlegen", style: .default) { (action) in
            
            self.showAddSensorController()
        }
        
        showAlertSheet(title: "", contentText: Constants.libraryOptionText, actions: [qrAction, beaconAction, noAction])
    }
    
    // alert sheet
    func showAlertSheet(title: String, contentText: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: contentText, preferredStyle: .actionSheet)
            for action in actions {
                alertController.addAction(action)
            }
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            if let presenter = alertController.popoverPresentationController {
                presenter.sourceView = self.addButton
                presenter.sourceRect = self.addButton.bounds
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // ------ VIEWS -----
    
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nicht dabei? Hier können Sie den Sensor manuell hinzufügen."
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Hinzufügen", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(white: 0, alpha: 0.06)
        button.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return button
    }()
    
    
    // ----- SETUP VIEWS ------
    
    func setupHeaderView() {
        
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(header)
        header.addSubview(addButton)
        header.addSubview(headlineLabel)
        
        header.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        headlineLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 20).isActive = true
        headlineLabel.widthAnchor.constraint(equalTo: header.widthAnchor, constant: -80).isActive = true
        headlineLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
        addButton.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20).isActive = true
        addButton.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        
    }
    
}

extension SensorLibraryController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorLibraryCell
        
        cell.device = Constants.devices[indexPath.item]
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.devices.count
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 140)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height: 130)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selected = Constants.devices[indexPath.item]
        
        showSensorDetailViewController(with: selected)
        
    }
    
}


