//
//  SensorDetailController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let resuableHeaderId = "resuableHeaderId"
    let cellId = "cellId"
    
    let data = [SensorModel(id: "12345", type: .Lautstärke, entity: .Lautstärke, value: 39, minValue: 0, maxValue: 30, time: "12:25")]
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor(red: 195/255, green: 14/255, blue: 26/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Temperatur"
        
        setupViews()

        setupCollectionView()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 1)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        
        collectionView?.register(SensorDetailCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    // dismiss viewcontroller
    
    func dismissViewController() {
    
        dismiss(animated: true, completion: nil)
    }

    

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorDetailCell
        
        let sensor = data[indexPath.item]
        
        
        // still placeholder text
        
        cell.typeLabel.text = "Wärmster Tag"
        cell.typeLabel2.text = "Kältester Tag"
        
        cell.valueLabel.text = "22° Celsius"
        cell.valueLabel2.text = "8° Celsius"
        
        cell.timeLabel.text = "12.05.17, 8:05 Uhr"
        cell.timeLabel2.text = "18.05.17, 14.30 Uhr"
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 220)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }

    

    
    
    func setupViews() {

        
        view.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        view.addSubview(valueLabel)
        
        valueLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        view.addSubview(timeLabel)
        
        timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        
        view.addSubview(maxValueLine)
        
        maxValueLine.bottomAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 90).isActive = true
        maxValueLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        maxValueLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        maxValueLine.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(chartView)
        
        chartView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 20).isActive = true
        chartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        chartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    lazy var chartView: ChartView = {
        let c = ChartView()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
        
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 14)
        lv.textColor = .black
        lv.textAlignment = .center
        return lv
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

