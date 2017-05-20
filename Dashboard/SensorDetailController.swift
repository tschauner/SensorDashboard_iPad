//
//  SensorDetailController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 20.05.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit

class SensorDetailController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Statistik"
        
        setupViews()
    }
    
    func dismissViewController() {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.75)
        let topColor = UIColor(red: 153/255, green: 217/255, blue: 244/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 107/255, green: 200/255, blue: 240/255, alpha: 1).cgColor
        
        layer.frame = colorView.bounds
        layer.colors = [topColor, bottomColor]
        
        colorView.clipsToBounds = true
        colorView.layer.insertSublayer(layer, at: 0)
    }
    
    func setupViews() {
        
        view.addSubview(colorView)
        
        colorView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        colorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        colorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        colorView.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        colorView.addSubview(valueLabel)
        
        valueLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 7).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -10).isActive = true
        
        colorView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        
    }
    
    var colorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4
        v.backgroundColor = UIColor(red: 153/255, green: 217/255, blue: 244/255, alpha: 1)
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
}
