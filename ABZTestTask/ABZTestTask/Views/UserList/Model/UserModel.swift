//
//  UserModel.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import Foundation
import UIKit

struct UserModel: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: TimeInterval
    let photoPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case position
        case positionId
        case registrationTimestamp
        case photoPath = "photo"
     }
}

extension UserModel {
    static func faceModel() -> [UserModel] {
        var list = [UserModel]()
        list.append(UserModel(id: 30,
                              name: "Angel",
                              email: "angel.williams@example.com",
                              phone: "+380496540023",
                              position: "Designer",
                              positionId: 4,
                              registrationTimestamp: 1537777441,
                              photoPath: "https://frontend-test-assignment-api.abz.agency/images/users/5b977ba13fb3330.jpeg"))
        
        list.append(UserModel(id: 29,
                              name: "Mattie",
                              email: "mattie.lee@example.com",
                              phone: "+380204819073",
                              position: "Designer",
                              positionId: 4,
                              registrationTimestamp: 1537777441,
                              photoPath: "https://frontend-test-assignment-api.abz.agency/images/users/5b977ba1245cc29.jpeg"))
        
        return list
    }
}

struct SignInUserModel {
    var name: String?
    var email: String?
    var phone: String?
    var position: String?
    var image: UIImage?
}
