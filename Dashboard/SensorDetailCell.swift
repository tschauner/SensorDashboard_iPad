//
//  SensorDetailCell.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 25.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorDetailCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            colorView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.95) : CGAffineTransform.identity
//        }
//    }
    
    var niceBlue = UIColor(red: 153/255, green: 217/255, blue: 244/255, alpha: 1)
    var niceGreen = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 1)
    
    // Variables
    
    var sectionLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.textColor = .black
        lv.text = "Diese Woche"
        lv.textAlignment = .left
        return lv
    }()
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 1)
        return v
        
    }()
    
    var colorView2: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(red: 185/255, green: 210/255, blue: 156/255, alpha: 1)
        return v
        
    }()
    
    var typeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var typeLabel2: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.boldSystemFont(ofSize: 16)
        lv.textColor = .white
        lv.textAlignment = .left
        return lv
    }()
    
    var valueLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 22)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var valueLabel2: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 22)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var timeLabel2: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var messageLabel: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    var messageLabel2: UILabel = {
        let lv = UILabel()
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.font = UIFont.systemFont(ofSize: 14)
        lv.textColor = .white
        lv.textAlignment = .right
        return lv
    }()
    
    
    // setup views
    
    func setupViews() {
        
        addSubview(sectionLabel)
        
        addSubview(colorView)
        addSubview(colorView2)
        
        // first
        
        sectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        colorView.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 10).isActive = true
        colorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        colorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        colorView.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        colorView.addSubview(valueLabel)
        
        valueLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 7).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -10).isActive = true
        
        colorView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        
        colorView.addSubview(messageLabel)
        messageLabel.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        
        //second
        
        colorView2.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10).isActive = true
        colorView2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        colorView2.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        colorView2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        colorView2.addSubview(typeLabel2)
        
        typeLabel2.topAnchor.constraint(equalTo: colorView2.topAnchor, constant: 10).isActive = true
        typeLabel2.leftAnchor.constraint(equalTo: colorView2.leftAnchor, constant: 10).isActive = true
        
        colorView2.addSubview(valueLabel2)
        
        valueLabel2.topAnchor.constraint(equalTo: colorView2.topAnchor, constant: 7).isActive = true
        valueLabel2.rightAnchor.constraint(equalTo: colorView2.rightAnchor, constant: -10).isActive = true
        
        colorView2.addSubview(timeLabel2)
        
        timeLabel2.topAnchor.constraint(equalTo: valueLabel2.bottomAnchor).isActive = true
        timeLabel2.rightAnchor.constraint(equalTo: valueLabel2.rightAnchor).isActive = true
        
        colorView2.addSubview(messageLabel2)
        
        messageLabel2.leftAnchor.constraint(equalTo: typeLabel2.leftAnchor).isActive = true
        messageLabel2.topAnchor.constraint(equalTo: timeLabel2.topAnchor).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
