//
//  HomeControllerDelegates.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 17.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


// Delegates

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    // Funktion zum bewegen und verschieben der Cells im CollectionView
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = Constants.sensorData.remove(at: sourceIndexPath.item)
        Constants.sensorData.insert(temp, at: destinationIndexPath.item)
    }
    
    // Funktion gibt die Cell zurück und legt fest was in der Cell angezeigt wird
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SensorTileCell
        cell.sensor = Constants.sensorData[indexPath.item]
        
        // zeigt den Alarm an, falls ein Wert überschritten wurde
        showAlarmFor(sensor: cell.sensor!)
        
        return cell
    }
    
    
    // Funktion gibt die Anzahl der Objecte im ColectionView zurück
    // - Wenn die Anzahl == 0, pulsierende Ringe werden angezeigt
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Constants.sensorData.count == 0 {
            collectionView.backgroundView = backGroundView()
            return 0
        } else {
            collectionView.backgroundView = UIView()
            return Constants.sensorData.count
            
        }
    }
    
    // Funktion gibt Anzahl der Sections zurück
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Funktion gibt Größe des Headers zurück
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 90)
        
    }
    
    // Funktion gibt die Größe der Cells zurück
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.bounds.size.width  / 4)
        
        return CGSize(width: itemWidth - 10, height: 150)
    }
    
    // Funktion gibt Space zwischen den Cells zurück
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
    // Funktion zeigt DetailController an wenn Cell gedrückt wird
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = Constants.sensorData[indexPath.item]
        
        show(sensorData: data)
        
        
    }
    
}

// Extension für den BackgroundView im HomeController
// zeigt die pulsierenden Kreise wenn keine Sensoren im Array sind
extension HomeController {
    
    func backGroundView() -> UIView {
        
        let containerView = UIView()
        containerView.frame = view.bounds
        containerView.center = CGPoint(x: view.center.x - 40, y: view.center.y - 80)
        
        containerView.backgroundColor = .darkGray
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        
        label.text = "Keine Sensoren\nin Reichweite"
        
        let size: CGFloat = 50
        let scalefactor: CGFloat = 10

        
        let shapeView = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView.layer.borderWidth = 0.4
        shapeView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        shapeView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        shapeView.layer.cornerRadius = 25
        shapeView.isHidden = true
        
        
        // erster Ring
        
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView.isHidden = false
            shapeView.transform = CGAffineTransform(scaleX: scalefactor, y: scalefactor)
            shapeView.alpha = 0
            
            
        }, completion: nil)
        
        let shapeView2 = UIView(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: size, height: size))
        shapeView2.layer.borderWidth = 0.4
        shapeView2.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        shapeView2.backgroundColor = UIColor(white: 1, alpha: 0.2)
        shapeView2.layer.cornerRadius = 25
        shapeView2.isHidden = true
        
        containerView.addSubview(shapeView2)
        
        
        // zweiter Ring
        
        UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseOut, .repeat], animations: {
            
            shapeView2.isHidden = false
            shapeView2.transform = CGAffineTransform(scaleX: scalefactor, y: scalefactor)
            shapeView2.alpha = 0
            
        }, completion: nil)
        
        
        containerView.addSubview(shapeView)
        containerView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -100).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        
        return containerView
    }
    
}



