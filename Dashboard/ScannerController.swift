//
//  ScannerController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 15.06.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import Foundation


import AVFoundation
import UIKit

class ScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //available devices
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeQRCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        initScanner()
    }
    
    // Funktion für die Initialisierung des Scanners
    func initScanner() {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: contentView)
            //            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    // Funktion startet bevor der VC zu sehen ist
    // 1. QR code scanner wird gestartet
    override func viewWillAppear(_ animated: Bool) {
        captureSession?.startRunning()
    }
    
    // Funktion zeigt den DetailViewController von dem jeweiligen Device an
    // als Parameter wird das device übergeben
    func showDetailView(with device: DeviceModel) {
        
        let sensorDetail = SensorDetailViewController()
        sensorDetail.device = device
        let nav = UINavigationController(rootViewController: sensorDetail)
        present(nav, animated: true, completion: nil)
    }
    
    
    // Funktion prüft ob die Device Id == der Id vom QR code ist
    // 1. wenn die ID gleich ist, wird der jeweilige VC angezeigt
    func scannerAction(with id: String) {
        
        for device in Constants.devices {
            
            if device.id == id {
                showDetailView(with: device)
                
            } else {
                print("something went wrong")
            }
        }
        
    }
    
    // Funktion um den ViewController auszublenden
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // -------- SETUP VIEWS ---------
    
    func setupViews() {
        
        view.addSubview(contentView)
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(headlineLabel)
        
        headlineLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        headlineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contentView.addSubview(messageLabel)
        
        messageLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contentView.addSubview(cancelButton)
        
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor).isActive = true
        
    }
    
    // ------ VIEWS --------
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        return view
    }()
    
    //qr code image
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "qr")
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mit Sensor Code koppeln"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Positionieren Sie den Sensor Code im Rahmen.\nDer Sensor Code befindet sich auf dem Gerät."
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Abbrechen", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.layer.cornerRadius = 4
        button.alpha = 0
        button.titleLabel?.text = "Sensor hinzufügen"
        return button
    }()
    
    
    // AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR/barcode is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                print("das ist der scann", metadataObj.stringValue)
                scannerAction(with: metadataObj.stringValue)
            }
        }
    }
    
}
