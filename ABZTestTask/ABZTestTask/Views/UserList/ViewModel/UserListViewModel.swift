//
//  UserListViewModel.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import Foundation


protocol UserListViewModel: ObservableObject, AnyObject {
    var userList: [UserModel]? { get }
    var isLoading: Bool { get }
    func fetchUsers() async
    func refresh() async
}

class UserListViewModelType: UserListViewModel {
    
    @Published var userList: [UserModel]? // = UserModel.faceModel()
    @Published var isLoading: Bool = false
    
    let endpoint: LoadUsersEndpoint = LoadUsersEndpointType()
    
    
    private var currentPage: Int = 1
    private let count: Int = 10
    
    func loadUsers() {
        self.userList = UserModel.faceModel()
    }
    
    func fetchUsers() async {
        let result = await endpoint.fetchUsers(page: currentPage, count: count)
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success(let list):
                self.currentPage += 1
                self.userList?.append(contentsOf: list)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    @MainActor
    func refresh() async {
        self.isLoading = true
        if userList == nil {
            userList = [UserModel]()
        }
        userList?.removeAll()
        currentPage = 1
        await fetchUsers()
    }
}
