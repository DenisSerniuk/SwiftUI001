//
//  ImageResource+Halper.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 14.06.2025.
//

import Foundation
import SwiftUI

extension ImageResource {
    static func resource(_ name: String) -> ImageResource {
        if let stringPath = Bundle.main.path(forResource: "Preview Assets",
                                             ofType: "Assets.xcassets"),
            let bundle = Bundle(path: stringPath)
        {
            return ImageResource(name: name, bundle: bundle)
        }
        return ImageResource(name: name, bundle: .main)
    }
}
