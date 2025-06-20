//
//  Coordinator.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import Foundation
import SwiftUI


class Coordinator: ObservableObject {
    enum Page: String, Identifiable {
        var id: String {
            self.rawValue
        }
        
        case noInternet, users
        
    }
    
    @Published var path = NavigationPath()
    
    // MARK - Pages
    func push(_ page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(_ page: Page) -> some View {
        switch page {
        case .noInternet:
            NoInternetView(update: {
                self.pop()
            })
        case .users:
            UserListView(viewModel: UserListViewModelType())
        }
    }
    
}
