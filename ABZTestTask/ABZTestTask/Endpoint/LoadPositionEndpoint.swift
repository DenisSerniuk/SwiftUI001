//
//  LoadPositionEndpoint.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 16.06.2025.
//

import Foundation

fileprivate struct APIPositionModel: Codable {
    let success: Bool
    let positions: [PositionModel]
}

protocol LoadPositionEndpoint {
    func fetchPositionList() async -> Result<[PositionModel], APIError>
    func getList(completion: @escaping (Result<[PositionModel], APIError>) -> Void)
}

final class LoadPositionEndpointType: LoadPositionEndpoint {
    enum Enpoint {
        static var postion: URL {
            APIEnviropment.current.url().appending(path: "positions")
        }
    }
    
    func getList(completion: @escaping (Result<[PositionModel], APIError>) -> Void) {
        var request = URLRequest(url: Enpoint.postion)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.error(networkError: error)))
            } else if let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let data = data  {
                completion(self.dataToModel(data: data))
            } else {
                print("ooooops")
            }
        }
        
        task.resume()
    }
    
    func fetchPositionList() async -> Result<[PositionModel], APIError> {
        var request = URLRequest(url: Enpoint.postion)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(.unexpected(code: 0))
            }
            
            let model = try JSONDecoder().decode(APIPositionModel.self, from: data)
            return .success(model.positions)
        } catch {
            return .failure(.errorString(description: "Sending error"))
        }
    }
    
    private func dataToModel(data: Data) -> Result<[PositionModel], APIError> {
        do {
            let model = try JSONDecoder().decode(APIPositionModel.self, from: data)
            return .success(model.positions)
        } catch let error {
            return .failure(.parsing(description: error))
        }
    }
}
