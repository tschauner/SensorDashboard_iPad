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
    
    let data = [SensorModel(id: "12345", type: .Lautstärke, entity: .Lautstärke, value: 39, minValue: 0, maxValue: 50, time: "12:25")]
    
    var minColor = UIColor(red: 98/250, green: 139/255, blue: 200/255, alpha: 1)
    var maxColor = UIColor(red: 195/255, green: 14/255, blue: 26/255, alpha: 1)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Statistik"
        
        setupViews()
        
        initGestures()
        
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
    
    override func viewDidLayoutSubviews() {
        
        // gradient color
        
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
    
    // initializing gesture
    
    func initGestures() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dissmissPan))
        colorView.addGestureRecognizer(pan)
    }
    
    
    func dissmissPan(pan: UIPanGestureRecognizer) {
        
        var translation = pan.translation(in: colorView)
        
        translation = __CGPointApplyAffineTransform(translation, colorView.transform)
        
        colorView.center.y += translation.y
        
          print(self.colorView.frame.origin.y)
        
        pan.setTranslation(CGPoint.zero, in: colorView)
        
        if pan.state == UIGestureRecognizerState.ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
                
                // dismiss vc if y < 120
                
                switch(self.colorView.frame.origin.y) {
                case (120...360):
                    self.dismissViewController()
                default:
                    self.colorView.frame.origin.y = 50
                    
                }
              
            }, completion: nil)
        }
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
        
        
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }

    

    
    
    func setupViews() {

        
        view.addSubview(colorView)
        
        colorView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        colorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        colorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        colorView.addSubview(typeLabel)
        
        typeLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 10).isActive = true
        typeLabel.leftAnchor.constraint(equalTo: colorView.leftAnchor, constant: 10).isActive = true
        
        colorView.addSubview(valueLabel)
        
        valueLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 7).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: colorView.rightAnchor, constant: -10).isActive = true
        
        colorView.addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: valueLabel.rightAnchor).isActive = true
        
        colorView.addSubview(seperatorLine)
        
        seperatorLine.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -30).isActive = true
        seperatorLine.leftAnchor.constraint(equalTo: typeLabel.leftAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperatorLine.rightAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        
        colorView.addSubview(chartView)
        
        chartView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        chartView.leftAnchor.constraint(equalTo: colorView.leftAnchor).isActive = true
        chartView.rightAnchor.constraint(equalTo: colorView.rightAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }
    
    lazy var chartView: ChartView = {
        let c = ChartView()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
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
    
    var seperatorLine: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(white: 1, alpha: 0.6)
        return l
    }()
}

