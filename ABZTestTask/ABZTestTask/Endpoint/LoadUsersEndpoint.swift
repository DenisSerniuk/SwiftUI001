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

protocol LoadUsersEndpoint {
    func fetchUsers(page: Int, count: Int) async -> Result<[UserModel], APIError>
}

class LoadUsersEndpointType: LoadUsersEndpoint {

    enum Enpoint {
        static func users(page: Int, count: Int) -> URL {
            return APIEnviropment.current.url()
                .appending(path: "users")
                .appending(queryItems: [URLQueryItem(name: "page", value: "\(page)"),
                                        URLQueryItem(name: "count", value: "\(count)")])
        }
    }
    
    func fetchUsers(page: Int, count: Int) async -> Result<[UserModel], APIError> {
        var request = URLRequest(url: Enpoint.users(page: page, count: count))
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.unexpected(code: 0))
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let apiModel = try decoder.decode(UserAPIModel.self, from: data)
                return .success(apiModel.users)
            } catch let error {
                print("error: \(error)")
                return .failure(.errorString(description: "Decoding Error: \(error)"))
            }

        } catch {
            return .failure(.errorString(description: "Sending error"))
        }
    }
}
