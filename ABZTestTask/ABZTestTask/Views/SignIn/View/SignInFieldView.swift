//
//  SignInFieldView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import SwiftUI

enum FieldState {
    case normal, focused, error
    
    func color() -> Color {
        switch self {
        case .normal:
            return .boderGrayColor
        case .focused:
            return .secondary
        case .error:
            return .appRed
        }
    }
    
    func textColor() -> Color {
        switch self {
        case .normal:
            return .black60Color
        case .focused:
            return .black60Color
        case .error:
            return .appRed
        }
    }
}

struct SignInFieldView: View {
    
    @Binding var text: String
    let placeholder: String
    @Binding var infoText: String
    @Binding var state: FieldState
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .padding(12)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(state.color(),
                                      style: StrokeStyle(lineWidth: 1))
                }
            if !infoText.isEmpty {
                Text(infoText)
                    .foregroundStyle(state.textColor())
                    .padding(.leading, 10)
                    .frame(height: 16)
            } else {
                Spacer(minLength: 16)
            }

        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var state: FieldState = .normal
    @Previewable @State var infoText: String = ""
    SignInFieldView(text: $text,
                    placeholder: "Email",
                    infoText: $infoText,
                    state: $state)
}
