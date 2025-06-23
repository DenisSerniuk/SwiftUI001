//
//  LoadUsersEndpoint.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 16.06.2025.
//

import Foundation

fileprivate struct UserAPIModel: Codable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let users: [UserModel]
}

fileprivate struct UserFailAPIModel: Codable {
    struct FailsAPIModel: Codable {
        let page: [String]
    }
    
    let success: Bool
    let message: String
    let fails: FailsAPIModel
}

struct UserListModel {
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let users: [UserModel]
}

protocol LoadUsersEndpoint {
    func fetchUsers(page: Int, count: Int) async throws -> UserListModel
}

final class LoadUsersEndpointType: LoadUsersEndpoint {

    enum Endpoint {
        static func users(page: Int, count: Int) -> URL {
            return APIEnviropment.current.url()
                .appending(path: "users")
                .appending(queryItems: [URLQueryItem(name: "page", value: "\(page)"),
                                        URLQueryItem(name: "count", value: "\(count)")])
        }
    }
    private let decoder = AppResponseDecoder()
    
    func fetchUsers(page: Int, count: Int) async throws -> UserListModel {
        var request = URLRequest(url: Endpoint.users(page: page, count: count))
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let model = try decoder.parceJson(data: data, model: UserAPIModel.self)
                return mapper(model)
            } else {
                let failData = try decoder.parceJson(data: data, model: UserFailAPIModel.self)
                throw(APIError.errorString(description: failData.message))
            }
        } catch {
            throw(APIError.errorString(description: "Can't send request"))
        }
    }
    
}

extension LoadUsersEndpointType {
    private func mapper(_ model: UserAPIModel) -> UserListModel {
        UserListModel(totalPages: model.totalPages,
                      totalUsers: model.totalUsers,
                      count: model.count,
                      page: model.page,
                      users: model.users)
    }
}
