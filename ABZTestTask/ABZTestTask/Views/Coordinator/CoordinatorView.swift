//
//  CoordinatorView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import SwiftUI

struct CoordinatorView: View {
    
    @State private var usersCoordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $usersCoordinator.path) {
            usersCoordinator.build(.users)
        }.navigationDestination(for: Coordinator.Page.self) { page in
            usersCoordinator.build(page)
        }.environmentObject(usersCoordinator)
    }
}

#Preview {
    CoordinatorView()
}
