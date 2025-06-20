//
//  PositionModel.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 16.06.2025.
//

import Foundation

struct PositionModel: Codable, Hashable {
    let id: Int
    let name: String
}

extension PositionModel {
    static func faceList() -> [PositionModel] {
        return [PositionModel(id: 1, name: "Lawyer"),
                PositionModel(id: 2, name: "Content manager"),
                PositionModel(id: 3, name: "Security"),
                PositionModel(id: 4, name: "Designer")]
    }
}
