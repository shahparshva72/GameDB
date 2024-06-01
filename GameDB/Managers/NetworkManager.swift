//
//  NetworkManager.swift
//  GameDB
//
//  Created by Parshva Shah on 5/15/24.
//

import Foundation
import Network
import Combine

class NetworkManager: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected: Bool = true
    @Published var connectionType: NWInterface.InterfaceType?

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = path.availableInterfaces.first(where: { path.usesInterfaceType($0.type) })?.type
            }
        }
        monitor.start(queue: queue)
    }
}
