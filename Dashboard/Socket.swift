//
//  Socket.swift
//  Dashboard
//
//  Created by Philipp Tschauner on 01.07.17.
//  Copyright © 2017 Philipp Tschauner. All rights reserved.
//

import Foundation
import UIKit
import SwiftSocket


class Socket {
    
    let client: TCPClient?
    let host = "141.45.208.222"
    let port = 8080
    
    //Singleton
    static var sharedInstance = Socket()
    
    init() {
        client = TCPClient(address: host, port: Int32(port))
    }
    
    func sendData(with request: String) {
        guard let client = client else { return }
        
        switch client.connect(timeout: 10) {
        case .success:
            printStatus(string: "Connected to host \(client.address)")
            if let response = sendRequest(string: "\(request)\n", using: client) {
                printStatus(string: "Response: \(response)")
            }
        case .failure(let error):
            printStatus(string: String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        printStatus(string: "Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            printStatus(string: String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    private func printStatus(string: String) {
        print(string)
    }
}
