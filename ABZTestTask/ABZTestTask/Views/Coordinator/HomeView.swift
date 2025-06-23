//
//  HomeView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 17.06.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = SignInViewModelType(signInEndpoint: SignInEndpointType(), positionEndpoint: LoadPositionEndpointType())

    var body: some View {
        // little bin not by design, but for test ok
        TabView {
            CoordinatorView()
                .tabItem {
                    Label("Users", systemImage: "person.3.sequence.fill")
                }.tag(0)
            SignInView(viewModel: viewModel).tabItem {
                Label("SignIn", systemImage: "person.crop.circle.badge.plus")
            }.tag(1)
        }.tint(.secondary)
    }
}

#Preview {
    HomeView()
}
