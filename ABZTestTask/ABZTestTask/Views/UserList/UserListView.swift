//
//  UserListView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import SwiftUI

struct UserListView<Model>: View where Model: UserListViewModel  {
    @State private var selectedUser: UserModel?
    @StateObject var viewModel: Model
    @State private var isFinished: Bool = false
    @State private var isLoading = false
    @State private var isAnimation = true
        
    var body: some View {
        NavigationStack {
            Group {
                if let list = viewModel.userList {
                    List {
                        ForEach(list) {
                            UserCellView(name: $0.name,
                                         role: $0.position,
                                         contactInfo: $0.email,
                                         phoneInfo: $0.phone,
                                         imagePath: $0.photoPath)
                        }
                        if !viewModel.isLoading {
                            ProgressViewCell().onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    Task {
                                        await viewModel.fetchUsers()
                                    }
                                })
                            }.id(UUID())
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                    .listStyle(.plain)
                } else {
                    NoUsersView()
                }
            }.onAppear {
                // add dalay to show no users screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    Task {
                        await viewModel.refresh()
                    }
                })
            }
            .navigationTitle("Working with GET request")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primary, for: .automatic)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        }
        
    }
}

struct LoaderIndicator: UIViewRepresentable {
    
    @Binding var isAnimating:Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<LoaderIndicator>) ->  UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoaderIndicator>) {
        if isAnimating {
            uiView.startAnimating()
        }else{
            uiView.stopAnimating()
        }
    }
}

#Preview {
    UserListView<UserListViewModelType>(viewModel: UserListViewModelType())
}

