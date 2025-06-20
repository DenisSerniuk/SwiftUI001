//
//  SignInEndpoint.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 17.06.2025.
//

import Foundation

protocol MultipartData {
    var name: String { get }
    var value: String { get }
}

struct SignInSuccessAPIModel: Codable {
    let success: Bool
    let userId: Int
    let message: String
}

struct SignInFailAPIModel: Codable {
    let success: Bool
    let message: String
    var fails: String
}

protocol SignInEndpoint {
    func signIn(name: String, email: String, phone: String, positionID: Int, photoData: Data) async throws -> String?
}

class SignInEndpointType: SignInEndpoint {
    struct MultipartDataType: MultipartData {
        let name: String
        let value: String
    }
    
    let session = URLSession.shared
    private let decode = AppResponseDecoder()
    
    enum Enpoint {
        static var signIn: URL {
            APIEnviropment.current.url().appending(path: "users")
        }
    }
    
    func signIn(name: String, email: String, phone: String, positionID: Int, photoData: Data) async throws -> String? {
        
        guard let token = AppTokenService().fetchToken() else {
            throw(APIError.errorString(description: "Can't find token"))
        }
        
        var request = URLRequest(url: Enpoint.signIn)
        request.addValue(token, forHTTPHeaderField: "token")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        var body = Data()
        if let paramsData = multipartTextFormData(boundary: boundary,
                                                  inputList: [MultipartDataType(name: "name",
                                                                                value: name),
                                                              MultipartDataType(name: "email",
                                                                                value: email),
                                                              MultipartDataType(name: "phone",
                                                                                value: phone),
                                                              MultipartDataType(name: "position_id",
                                                                                value: "\(positionID)")]) {
            body.append(paramsData)
        }
        if let imageData = multipartImageFormData(boundary: boundary, imageData: photoData, name: "photo") {
            body.append(imageData)
        }
        
        if let boundaryData = "--\(boundary)--\r\n".data(using: .utf8) {
            body.append(boundaryData)
        }
        
        request.httpMethod = "POST"
        request.httpBody = body
        
        do {
            let (data, response) = try await session.data(for: request)
            
            var code = 0
            if let httpResponse = response as? HTTPURLResponse {
                code = httpResponse.statusCode
            }
            
            if code == 201 {
                let model:SignInSuccessAPIModel = try decode.parceJson(data: data, model: SignInSuccessAPIModel.self)
                return model.message
            } else {
                let model:SignInFailAPIModel = try decode.parceJson(data: data, model: SignInFailAPIModel.self)
                throw(APIError.errorString(description: model.message))
            }
        } catch {
            throw(APIError.sending)
        }
    }
            
    // MARK: - Multipart
    // good to marge in on func func
    private func multipartTextFormData(boundary: String, inputList: [MultipartData]) -> Data? {
        var body = ""
        for data in inputList {
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(data.name)\""
            body += "\r\n\r\n\(data.value)\r\n"
        }
        return body.data(using: .utf8)
    }
    
    private func multipartImageFormData(boundary: String, imageData: Data, name: String) -> Data? {
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition: form-data; name=\"\(name)\""
        body += "; filename=\"photo.jpeg\"\r\n"
        body += "Content-Type: image/jpeg \r\n\r\n"
        if var bodyData = body.data(using: .utf8),
           let ending = "\r\n".data(using: .utf8) {
            bodyData.append(imageData)
            bodyData.append(ending)
            return bodyData
        }
        
        return nil
    }
}
