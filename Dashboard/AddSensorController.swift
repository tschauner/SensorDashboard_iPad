//
//  AddSensorController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 11.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import UIKit


class AddSensorController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerView = UIPickerView()
    
    let sensorTypes = ["Temperatur", "Luftfeuchtigkeit", "Sauerstoff", "Kohlenmonoxid", "Helligkeit", "Infrarot", "Luftdruck"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        
        // remove the shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isTranslucent = false
        
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        
        pickerView.delegate = self
        pickerView.dataSource = self

        setupViews()
        
        initTapGesture()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bitte geben Sie die UUID und den Minor Value des neuen Sensors ein."
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name (Optional)"
        tf.textColor = UIColor(white: 0, alpha: 1)
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.06)
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = UITextFieldViewMode.always
        tf.layer.cornerRadius = 4
        return tf
    }()
    
    var uuidTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "UUID"
        tf.textColor = UIColor(white: 0, alpha: 1)
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.06)
        tf.autocapitalizationType = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = UITextFieldViewMode.always
        tf.layer.cornerRadius = 4
        return tf
    }()
    
    var minorTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Minor Value"
        tf.textColor = UIColor(white: 0, alpha: 1)
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.backgroundColor = UIColor(white: 0, alpha: 0.06)
        tf.keyboardType = .decimalPad
        tf.autocapitalizationType = .none
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = UITextFieldViewMode.always
        tf.layer.cornerRadius = 4
        return tf
    }()
    
    var touchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(white: 0, alpha: 0.06)
        return view
    }()
    
    var typeTextField: UILabel = {
        let tf = UILabel()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = "Sensortype"
        tf.textColor = UIColor(white: 0, alpha: 1)
        tf.contentMode = .left
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Hinzufügen", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(saveSensor), for: .touchUpInside)
        return button
    }()
    

    
    enum SensorType: String {
        case Temperatur = "Temperatur"
        case Luftfeuchtigeit = "Luftfeuchtigkeit"
        case Sauerstoff = "Sauerstoff"
        case Kohlenmonoxid = "Kohlenmonoxid"
        case Helligkeit = "Helligkeit"
        case Infrarot = "Infrarot"
        case Luftdruck = "Luftdruck"
    }
    
    func saveSensor() {
        
    }
    
    func dismissView() {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func initTapGesture() {
        
        let pan = UITapGestureRecognizer(target: self, action: #selector(showPickerView))
        touchView.addGestureRecognizer(pan)
        
    }
    
    func showPickerView() {
        
        print("tapped")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { 
            
            self.pickerView.alpha = 1
            self.addButton.alpha = 0
            
        }, completion: nil)
    }
    
    
    func setupViews() {
        
        
        view.addSubview(pickerView)
        
        view.addSubview(addButton)
        view.addSubview(headlineLabel)
        view.addSubview(uuidTextField)
        view.addSubview(minorTextField)
        view.addSubview(touchView)
        view.addSubview(typeTextField)
        
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerView.alpha = 0
        
        
        headlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 40).isActive = true
        headlineLabel.widthAnchor.constraint(equalToConstant: 350).isActive = true
        headlineLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        
        uuidTextField.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 50).isActive = true
        uuidTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -250).isActive = true
        uuidTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        uuidTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        minorTextField.topAnchor.constraint(equalTo: uuidTextField.bottomAnchor, constant: 20).isActive = true
        minorTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -250).isActive = true
        minorTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        minorTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        touchView.topAnchor.constraint(equalTo: minorTextField.bottomAnchor, constant: 20).isActive = true
        touchView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -250).isActive = true
        touchView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        touchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        typeTextField.leftAnchor.constraint(equalTo: touchView.leftAnchor, constant: 20).isActive = true
        typeTextField.centerYAnchor.constraint(equalTo: touchView.centerYAnchor).isActive = true
        
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sensorTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        typeTextField.text = sensorTypes[row]
        pickerView.alpha = 0
        self.addButton.alpha = 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sensorTypes.count
    }
    
    
    
}
