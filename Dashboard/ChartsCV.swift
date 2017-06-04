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
    let week = ["M", "D", "M", "D", "F", "S", "S"]
    
    static var data = [SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 8, minValue: 0, maxValue: 50, time: "0"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 10, minValue: 0, maxValue: 50, time: "1"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 12, minValue: 0, maxValue: 50, time: "2"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 16, minValue: 0, maxValue: 50, time: "3"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 19, minValue: 0, maxValue: 50, time: "4"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 22, minValue: 0, maxValue: 50, time: "0"), SensorModel(id: "12345", type: .Temperatur, entity: .Temperatur, value: 22, minValue: 0, maxValue: 50, time: "1")]

    
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
        
        cell.weekLabel.text = week[indexPath.item]
        
        cell.menuHeightConstraint.constant = CGFloat(data.value!*3)
        
        return cell
    }
    
    
    // cell size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/7, height: 100)
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
        tl.textColor = .black
        tl.textAlignment = .left
        return tl
    }()
    
    var weekLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.font = UIFont.boldSystemFont(ofSize: 12)
        tl.textColor = .black
        tl.textAlignment = .left
        return tl
    }()
    
    
    var seperatorLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        return l
    }()
    
    var bar: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 1)
        l.layer.cornerRadius = 10
        return l
    }()
    
    
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(bar)
        addSubview(weekLabel)
        
        menuHeightConstraint = bar.heightAnchor.constraint(equalToConstant: 0)
        menuHeightConstraint.isActive = true

        bar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        bar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        weekLabel.topAnchor.constraint(equalTo: bar.bottomAnchor, constant: 10).isActive = true
        weekLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






