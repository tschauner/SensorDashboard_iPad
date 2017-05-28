//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 22.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // init eventBar
    
    lazy var chartsCV: ChartsCV = {
        let cv = ChartsCV()
        cv.chartView = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    // variables
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
        
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.text = "Temperatur"
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 22)
        lv.text = "22° Celsius"
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 14)
        lv.text = "12:24"
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    
    var minValue: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white
        return v
    }()
    
    var maxValue: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.red
        return v
    }()
    
    // setup views
    
    func setupViews() {
        
//
//        colorView.addSubview(typeLabel)
//        
//        typeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
//        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
//        
//        colorView.addSubview(valueLabel)
//        
//        valueLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 7).isActive = true
//        valueLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -10).isActive = true
//        
//        colorView.addSubview(timeLabel)
//        
//        timeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true
//        timeLabel.rightAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        
        self.addSubview(chartsCV)
        chartsCV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chartsCV.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        chartsCV.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        chartsCV.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
}

