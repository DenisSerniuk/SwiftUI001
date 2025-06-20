//
//  RegistrationStatusView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 14.06.2025.
//

import SwiftUI

enum UserStatus {
    case registared, error(String)
    
    func text() -> String {
        switch self {
        case .registared:
            return "User successfully registered"
        case let .error(text):
            return text
        }
    }
    
    func imageString() -> String {
        switch self {
        case .registared:
            return "Registered"
        case .error(_):
            return "RegisterFail"
        }
    }
    
    func buttonText() -> String {
        switch self {
        case .registared:
            return "Got it"
        case .error(_):
            return "Try again"
        }
    }
}


struct RegistrationStatusView: View {
    let status: UserStatus
    var action: ()->()?
    var closeAction: ()->()?

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Spacer()
                Button("", systemImage: "xmark") {
                    closeAction()
                }.tint(.black)
                
            }.padding(.trailing, 24)
            Spacer()
            Image(status.imageString())
            Text(status.text())
                .font(.system(size: 20))
            Button(status.buttonText()) {
                action()
            }.padding()
                .buttonStyle(AppButtonStyle())
            Spacer()
        }
    }
}

#Preview {
    RegistrationStatusView(status: .registared, action: {}, closeAction: {})
}
