//
//  NetworkMonitor.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 19/08/23.
//

import Foundation
import Network

final class NetworkMonitor {
    
    //MARK: Variables
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private (set) var isConnected = false
    public private (set) var connectionType: ConnectionType?
    
    //MARK: enum
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    //MARK: init
    private init() {
        monitor = NWPathMonitor()
    }
    
    //MARK: start Monitoring
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path: path)
        }
    }
    
    //MARK: stop Monitoring
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    //MARK: get Connection Type
    private func getConnectionType(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
