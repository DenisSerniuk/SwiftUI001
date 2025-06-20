//
//  TokenEndpoint.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 19.06.2025.
//

import Foundation

fileprivate struct TokenAPIModel: Codable {
    let success: Bool
    let token: String
}

struct TokenEndpointType {
    func loadToken() async throws -> Bool {
        let url = APIEnviropment.current.url().appending(path: "token")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let model: TokenAPIModel = try JSONDecoder().decode(TokenAPIModel.self, from: data)
                    return AppTokenService().saveToken(token: model.token)
                } catch let error {
                    throw(APIError.parsing(description: error))
                }
            }
        } catch {
            throw(APIError.sending)
        }
            
        return false
    }
}
