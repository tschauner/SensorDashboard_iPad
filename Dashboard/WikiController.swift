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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        let helpURL = URL(string: "https://www.google.com/")
        let helpRequest = URLRequest(url: helpURL!)
        
        webView.loadRequest(helpRequest)
    }
    

let webView: UIWebView = {
    let view = UIWebView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()


func setupWebView() {
    
    view.addSubview(webView)
    
    webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    
}

}
