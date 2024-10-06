//
//  NetworkManager.swift
//  GameDB
//
//  Created by Parshva Shah on 5/15/24.
//

import Combine
import Foundation
import Network
import UIKit

class NetworkManager: ObservableObject {
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var connectionType: NWInterface.InterfaceType?
    @Published private(set) var isSecureConnection: Bool = false

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    private var cancellable: AnyCancellable?

    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
        queue = DispatchQueue(label: "NetworkManager", qos: .background)
        setupMonitor()
    }

    private func setupMonitor() {
        cancellable = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.startMonitoring()
            }

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = path.availableInterfaces.first?.type
                self.isSecureConnection = path.isSecure
                self.handleConnectionChange()
            }
        }
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.start(queue: queue)
    }

    private func stopMonitoring() {
        monitor.cancel()
    }

    private func handleConnectionChange() {
        // Implement any specific logic for connection changes
        // For example, you might want to notify other parts of your app
    }

    deinit {
        stopMonitoring()
        cancellable?.cancel()
    }
}

private extension NWPath {
    var isSecure: Bool {
        return status == .satisfied && availableInterfaces.contains(where: { $0.type == .wifi || $0.type == .wiredEthernet })
    }
}
