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
    var isFinished: Bool { get }

    func fetchUsers() async
    func refresh() async
}



class UserListViewModelType: UserListViewModel {
    
    struct UserPageModel {
        var currentPage: Int = 1
        var count: Int = 10
        var totalUsers: Int?
        var totalPages: Int?
        var total: Int?
        
        mutating func reset() {
            self.currentPage = 1
            self.totalUsers = nil
            self.totalPages = nil
            self.total = nil
        }
    }
    
    @Published var userList: [UserModel]?
    @Published var isLoading: Bool = false
    @Published var isFinished: Bool = false
    
    let endpoint: LoadUsersEndpoint = LoadUsersEndpointType()
    
    private var pageModel: UserPageModel = UserPageModel()
    
    func loadUsers() {
        self.userList = UserModel.faceModel()
    }
    
    private func updayeIsFinished() {
        if let totalPages = pageModel.totalPages,
           let totalUsers = pageModel.totalUsers,
            totalPages > pageModel.currentPage ||
           totalUsers > (userList?.count ?? 0) {
            isFinished = false
        } else {
            isFinished = true
        }
    }
    
    // MARK: - API
    @MainActor
    func fetchUsers() async {
        do {
            let result = try await endpoint.fetchUsers(page: pageModel.currentPage, count: pageModel.count)
            self.isLoading = false
            self.pageModel.currentPage += 1
            self.userList?.append(contentsOf: result.users)
            pageModel.totalPages = result.totalPages
            pageModel.totalUsers = result.totalUsers
            updayeIsFinished()
        } catch let error {
            self.isLoading = false
            print("error: \(error)")
        }
    }
    
    @MainActor
    func refresh() async {
        self.isLoading = true
        if userList == nil {
            userList = [UserModel]()
        }
        userList?.removeAll()
        pageModel.reset()
        await fetchUsers()
    }
}
