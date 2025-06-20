//
//  Validator.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 18.06.2025.
//

import Foundation

enum ValidationError: Error {
    case empty
    case notValid
    case error(description: String)
}


struct AppValidator {
    enum ValidationType {
        case text(minLen: Int), email, phone
    }
        
    func validate(text: String, type: ValidationType) -> ValidationError? {
        switch type {
        case .text(let minLen):
            return validateText(text: text, len: minLen)
        case .email:
            return validateEmail(text: text)
        case .phone:
            return validatePhone(text: text)
        }
    }
    
    private func validateText(text: String, len: Int) -> ValidationError? {
        if text.isEmpty {
            return .empty
        } else if text.count < len {
            return .error(description: "is too short")
        }
        return nil
    }
    
    private func validateEmail(text: String) -> ValidationError? {
        if text.isEmpty {
            return .empty
        }
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        if emailPredicate.evaluate(with: text) {
            return nil
        }
        return .notValid
    }
    
    private func validatePhone(text: String) -> ValidationError? {
        if text.isEmpty {
            return .error(description: "is requered")
        }
        let countryCode = String(text.prefix(4))
        if countryCode == "+380" {
            return nil
        }
        return .notValid
    }

}

