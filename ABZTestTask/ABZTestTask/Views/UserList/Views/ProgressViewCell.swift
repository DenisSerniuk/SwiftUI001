//
//  ProgressViewCell.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 17.06.2025.
//

import SwiftUI

struct ProgressViewCell: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .frame(height: 40)
            Spacer()
        }.id(UUID())
    }
}
