//
//  ViewController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 19.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"

    var incomingData = [SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 22, minValue: 0, maxValue: 50, time: "12:25"),
                        SensorModel(id: "12345", type: .Helligkeit, entity: .Helligkeit, value: 100, minValue: 0, maxValue: 250, time: "12:25"),
                        SensorModel(id: "12345", type: .Luftfeuchtigkeit, entity: .Luftfeuchtigkeit, value: 40, minValue: 0, maxValue: 100, time: "12:50"),
                        SensorModel(id: "12345", type: .Lautstärke, entity: .Lautstärke, value: 34, minValue: 0, maxValue: 50, time: "12:25")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dashboard"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(eventButton))
        
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self

        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(SensorCell.self, forCellWithReuseIdentifier: cellId)

        setupHeaderView()
        
        
    }
    
    var headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.75)
        let topColor = UIColor(red: 235/255, green: 103/255, blue: 122/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 223/255, green: 63/255, blue: 85/255, alpha: 1).cgColor
        
        layer.frame = headerView.eventView.bounds
        layer.colors = [topColor, bottomColor]
        
        headerView.eventView.clipsToBounds = true
        
        headerView.eventView.layer.insertSublayer(layer, at: 0)
        

    }
    
    func setupHeaderView() {
        
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        switch (incomingData.count) {
        case 0:
            headerView.sectionLabel.text = "Keine Sensoren vorhanden"
            
        default:
            headerView.sectionLabel.text = "\(incomingData.count) Sensoren verfügbar"
        }
    }
    
    
    func show(sensorData: SensorModel) {
        
        let sc = SensorDetailController()
        let scVC = UINavigationController(rootViewController: sc)
        
        present(scVC, animated: true, completion: nil)
    }
    
    
    func eventButton() {
        add(event: EventModel(time: "12:04", text: .TemperaturMax))
    }
    
    
    
    
    func add(event: EventModel) {
        
        let newEvent = event
        EventBar.events.insert(newEvent, at: 0)
        headerView.eventBar.collectionView.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorCell
        
        let sensor = incomingData[indexPath.item]
        
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.75)
        let topColor = UIColor(red: 153/255, green: 217/255, blue: 244/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 107/255, green: 200/255, blue: 240/255, alpha: 1).cgColor
        
        layer.frame = headerView.eventView.bounds
        layer.colors = [topColor, bottomColor]
        
        cell.colorView.clipsToBounds = true
        cell.colorView.layer.insertSublayer(layer, at: 0)
        
        if let value = sensor.value {
            
            cell.typeLabel.text = sensor.type.rawValue
            cell.valueLabel.text = "\(value)\(sensor.entity.rawValue)"
            cell.timeLabel.text = sensor.time
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return incomingData.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        

        return CGSize(width: view.frame.width, height: 180)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = incomingData[indexPath.item]
        
        show(sensorData: data)
        
    }
    


}





