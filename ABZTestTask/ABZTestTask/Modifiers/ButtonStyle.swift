//
//  ButtonStyle.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import SwiftUI

struct AppButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(EdgeInsets(top: 12,
                                leading: 24,
                                bottom: 12,
                                trailing: 24))
            .font(.system(size: 18))
            .foregroundStyle(.black)
            .background {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 24).fill(.buttonPressed)

                } else {
                    RoundedRectangle(cornerRadius: 24).fill(.buttonNormal)
                }
            }
    }
}
