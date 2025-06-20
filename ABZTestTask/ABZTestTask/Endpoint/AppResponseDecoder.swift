//
//  AppResponceDecoder.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 20.06.2025.
//

import Foundation

struct AppResponseDecoder {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func parceJson<T: Codable>(data: Data, model: T.Type) throws -> T {
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch let error {
            throw(APIError.parsing(description: error))
        }
    }
}
