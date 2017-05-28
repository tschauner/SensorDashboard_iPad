//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 22.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartsCV: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    // init collectionView
    
    var chartView: UICollectionReusableView?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    let time = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 0]
    
    static var data = [SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 8, minValue: 0, maxValue: 50, time: "0"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 10, minValue: 0, maxValue: 50, time: "1"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 12, minValue: 0, maxValue: 50, time: "2"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 16, minValue: 0, maxValue: 50, time: "3"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 19, minValue: 0, maxValue: 50, time: "4"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 22, minValue: 0, maxValue: 50, time: "0"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 22, minValue: 0, maxValue: 50, time: "1"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 23, minValue: 0, maxValue: 50, time: "2"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 18, minValue: 0, maxValue: 50, time: "3"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 14, minValue: 0, maxValue: 50, time: "4"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 10, minValue: 0, maxValue: 50, time: "4"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 8, minValue: 0, maxValue: 50, time: "4")]

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ChartBarCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
        collectionView.reloadData()
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChartsCV.data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChartBarCell
        
        let data = ChartsCV.data[indexPath.item]
        
        cell.timeLabel.text = String(time[indexPath.item])
        
        cell.menuHeightConstraint.constant = CGFloat(data.value!*2)
        
        return cell
    }
    
    
    // cell size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/12, height: 100)
    }
    
    // cell spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChartBarCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    // variables
    var height: CGFloat = 0
    
    var menuHeightConstraint: NSLayoutConstraint!
    
    var timeLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.font = UIFont.systemFont(ofSize: 8)
        tl.textColor = .white
        tl.textAlignment = .left
        return tl
    }()
    
    
    var seperatorLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(white: 1, alpha: 0.3)
        return l
    }()
    
    var bar: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(white: 1, alpha: 0.5)
        l.layer.cornerRadius = 4
        return l
    }()
    
    
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(bar)
        addSubview(timeLabel)
        
        menuHeightConstraint = bar.heightAnchor.constraint(equalToConstant: 0)
        menuHeightConstraint.isActive = true

        bar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        bar.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 20).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






