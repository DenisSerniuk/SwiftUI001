//
//  ABZTestTaskApp.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import SwiftUI


@main
struct ABZTestTaskApp: App {
    @StateObject var monitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            if monitor.status == .connected {
                HomeView().environmentObject(monitor)
            } else {
                NoInternetView {
                    //
                }
            }
        }
    }
}
