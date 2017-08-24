//
//  WikiController.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 18.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import Foundation
import UIKit

class WikiController: UIViewController {
    
    var deviceName = ""
    var name = "KR_QUANTEC_ultra"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        openWebViewFor(device: deviceName)
        
    }
    
    
    // Funktion öffnet WebView des jeweiligen Devices
    // - switch ordnet device ids den jeweiligen Namen zu
    // - name wird an Url angehängt und WebView geöffnet
    func openWebViewFor(device: String) {
        
        switch device {
        case "device1":
            name = "KR_QUANTEC_ultra"
        case "device2":
            name = "Serverraum_22B"
        case "device3":
            name = "Gewächshaus_3_(Stevia)"
            
        default:
            print("something went wrong with the device")
        }
        
        guard let helpURL = URL(string: "http://192.168.178.57/SensorWiki/index.php/\(name)") else { return }
        let helpRequest = URLRequest(url: helpURL)
        
        webView.loadRequest(helpRequest)
    }
    
    // Initialisierung des WebView Containers
    let webView: UIWebView = {
        let view = UIWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ---- SETUP VIEWS-----
    
    func setupWebView() {
        
        view.addSubview(webView)
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
}
