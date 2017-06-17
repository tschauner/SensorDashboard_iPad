//
//  ChartView.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 22.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class ChartViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // init eventBar
    
    // variables
    
    var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.4, alpha: 1)
        view.layer.cornerRadius = 2
        return view
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.text = "Temperatur"
        lv.textColor = .black
        lv.textAlignment = .left
        return lv
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 22)
        lv.text = "22° Celsius"
        lv.textColor = .black
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 14)
        lv.text = "12:24"
        lv.textColor = .black
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
        
        self.addSubview(colorView)
        colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        colorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        colorView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
}

