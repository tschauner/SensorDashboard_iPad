//
//  SensorDetailController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"
    
    let data = [ SensorModel(id: "ss", type: .Kohlenmonoxid, entity: .Kohlenmonoxid, value: 105.6, minValue: 0, maxValue: 250, time: "Heute: 13:10"),
                 SensorModel(id: "ss", type: .Temperatur, entity: .Temperatur, value: 52, minValue: 0, maxValue: 50, time: "Heute: 13:10"),
                 SensorModel(id: "ss", type: .Luftdruck, entity: .Luftdruck, value: 13.25, minValue: 20, maxValue: 2500, time: "Heute: 13:10")]
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor(red: 195/255, green: 14/255, blue: 26/255, alpha: 1)
    
    var device: DeviceModel? = nil {
        didSet {
            if let device = device {
                
                // shows data of every device in Sensorview
                
                deviceImage.image = UIImage(named: device.image)
                deviceLabel.text = device.name
                
                let sensors = device.sensors
                
                let sensorStrings = sensors.map { $0.type.rawValue }
                
                typeLabel.text = sensorStrings.joined(separator: ", ")
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        
        navigationItem.leftBarButtonItem = cancelButton
    
        
        setupViews()

        setupCollectionView()
        
        setupNavBar()
    }
    
    func setupCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        collectionView?.backgroundColor = UIColor.darkGray
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        
        collectionView?.register(ChartViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func setupNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        // remove the shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // dismiss viewcontroller
    
    func dismissViewController() {
    
        dismiss(animated: true, completion: nil)
    }

    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChartViewCell
        
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 260)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.bounds.size.width  / 7)
        return CGSize(width: itemWidth - 3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 9
    }

    

    
    
    func setupViews() {

        view.backgroundColor = .darkGray
        
        view.addSubview(deviceImage)
        view.addSubview(deviceLabel)
        view.addSubview(typeLabel)
        view.addSubview(descriptionLabel)
        
        deviceImage.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        deviceImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        deviceImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deviceImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        deviceLabel.topAnchor.constraint(equalTo: deviceImage.topAnchor, constant: 30).isActive = true
        deviceLabel.leftAnchor.constraint(equalTo: deviceImage.rightAnchor, constant: 10).isActive = true
        
        typeLabel.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 5).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: deviceLabel.leftAnchor).isActive = true
        typeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: deviceImage.bottomAnchor, constant: 30).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: deviceImage.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
    }
    
    var deviceImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .yellow
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "roboter1")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        return image
        
    }()
    
    var deviceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "KR QUANTEC ultra"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Die Sensorik in der Lebensmitteltechnik bzw. Lebensmittelanalytik, auch Lebensmittelsensorik, beschäftigt sich mit der Bewertung von Eigenschaften mit den Sinnesorganen."
        label.textColor = UIColor(white: 0.9, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Temperatur"
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 60)
        lv.text = "22°"
        lv.textColor = .black
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 14)
        lv.text = "Letzter Stand: 12:24"
        lv.textColor = .black
        lv.textAlignment = .right
        return lv
    }()
    
    var maxValueLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.red
        return l
    }()
}

