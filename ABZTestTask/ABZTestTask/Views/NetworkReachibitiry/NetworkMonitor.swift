//
//  NetworkMonitor.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 18.06.2025.
//

import Foundation
import Network

enum NetworkStatus: String {
    case connected
    case disconnected
}

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var status: NetworkStatus = .connected
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.status = .connected
                    
                } else {
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
}
