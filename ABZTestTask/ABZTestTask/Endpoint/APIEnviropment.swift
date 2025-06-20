//
//  Enviropment.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 16.06.2025.
//

import Foundation

enum APIError: Error {
    case parsing(description: Error)
    case sending
    case errorString(description: String)
    case error(networkError: Error)
    case unexpected(code: Int)
}

struct APIEnviropment {
    enum Mode {
        case dev, production
        
        func url() -> URL {
            switch self {
            case .dev:
                guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1") else {
                    assertionFailure("can't valid url")
                    return URL(filePath: "http://google.com")!
                }
                return url
            case .production:
                guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1") else {
                    assertionFailure("can't valid url")
                    return URL(filePath: "http://google.com")!
                }
                return url
            }
        }
    }
    
    static let current: Mode = .dev
}
