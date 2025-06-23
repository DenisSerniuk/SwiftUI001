//
//  SignInViewModel.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import Foundation
import UIKit

enum SignInFieldType {
    case phone, email, name
}

struct SignInError {
    let error: String
    let type: SignInFieldType
}

struct SignInText: Identifiable, Hashable{
    let id = UUID().uuidString
    var title: String = ""
    var placeholder: String
    var state: FieldState = .normal
    var info: String = ""
}

struct SignInImage {
    var image: UIImage?
    var state: FieldState = .normal
    var info: String = ""
}

struct SignInResult {
    var isPresented: Bool = false
    var status: UserStatus = .registared
}

protocol SignInViewModel: ObservableObject, AnyObject {
    var name: SignInText { set get }
    var email: SignInText { set get }
    var phone: SignInText { set get }
    var avatar: SignInImage { set get }
    var fieldList: [SignInText]  { set get }
    var signInResult: SignInResult { set get }
    var isLoading: Bool { set get }
    var positions: [PositionModel] { set get }
    var selectedPosition: PositionModel? { set get }
    func signIn() async
    func fetchPositions() async
}

final class SignInViewModelType: SignInViewModel {
    
    struct ValidationResult {
        enum FieldType {
            case name, email, phone, image
        }
        let type: FieldType
        var info: String = ""
        var state: FieldState = .normal
    }
    
    enum Constants {
        static let phoneNumberInfo = "+38 (XXX) XXX - XX - XX"
        static let avatarImageSize = CGSize(width: 75, height: 75)
    }
    
    // MARK: - Private
    private let validator = AppValidator()
    private let sizeManager = ImageSizeManager()
    
    // MARK: - Public
    @Published var name: SignInText = SignInText(placeholder: "Your name")
    @Published var email: SignInText = SignInText(placeholder: "Email")
    @Published var phone: SignInText = SignInText(placeholder: "Phone",
                                                  info: Constants.phoneNumberInfo)
    @Published var fieldList: [SignInText] = {
        var list = [SignInText(placeholder: "Your name"), SignInText(placeholder: "Email")]
        return list
    }()
    @Published var avatar: SignInImage = SignInImage()
    @Published var isLoading: Bool = false
    @Published var selectedPosition: PositionModel?
    @Published var signInResult = SignInResult(isPresented: false)
    
    var positions: [PositionModel] = [PositionModel]()
    
    let signInEndpoint: SignInEndpoint
    let positionEndpoint: LoadPositionEndpoint
    let tokenEndpoint = TokenEndpointType()
    
    init(signInEndpoint: SignInEndpoint, positionEndpoint: LoadPositionEndpoint)  {
        self.signInEndpoint = signInEndpoint
        self.positionEndpoint = positionEndpoint
    }
    
    // MARK: - Validation
    @MainActor
    func validate() -> [ValidationResult] {
        
        var list = [ValidationResult]()
        list.append(validateName())
        list.append(validateEmail())
        list.append(validatePhone())
        list.append(validateImage())
        
        for data in list {
            switch data.type {
            case .name:
                name.info = data.info
                name.state = data.state
            case .email:
                email.info = data.info
                email.state = data.state
            case .phone:
                phone.info = data.info
                phone.state = data.state
            case .image:
                avatar.info = data.info
                avatar.state = data.state
            }
        }
        
        return list
    }
    
    private func validateName() -> ValidationResult {
        if let error = validator.validate(text: name.title, type: .text(minLen: 1)) {
            name.state = .error
            name.info = "Required field"
            return ValidationResult(type: .name, info: "Required field", state: .error)
        }
        
        return ValidationResult(type: .name)
    }
    
    private func validateEmail() -> ValidationResult {
        var result = ValidationResult(type: .email)
        if let error = validator.validate(text: email.title, type: .email) {
            result.state = .error
            switch error {
            case .empty:
                result.info = "Required field"
            case .notValid:
                result.info = "Invalid email format"
            case let .error(description):
                result.info = description
            }
            return result
        }
        return result
    }
    
    private func validatePhone() -> ValidationResult {
        var result = ValidationResult(type: .phone, info: Constants.phoneNumberInfo)
        if let error = validator.validate(text: phone.title, type: .phone) {
            result.state = .error
            switch error {
            case .empty:
                result.info = "Required field"
            case .notValid:
                result.info = "Invalid phone format"
            case let .error(description):
                result.info = description
            }
            return result
        }
        return result
    }
    
    private func validateImage() -> ValidationResult {
        if avatar.image == nil {
            return ValidationResult(type: .image, info: "Photo is required", state: .error)
        }
        return ValidationResult(type: .image, info: "", state: .normal)
    }
    
    private func compessImageIfNeed() -> Data? {
        if let avatarImg = avatar.image,
           avatarImg.size.width > Constants.avatarImageSize.width ||
            avatarImg.size.height > Constants.avatarImageSize.height {
            let image = sizeManager.resizeImage(image: avatarImg, to: .small(size: Constants.avatarImageSize))
            let cropedImage = sizeManager.crop(image: image, to: CGRect(origin: .zero, size: Constants.avatarImageSize))
            
            if let cropedImage = cropedImage, sizeManager.isValidImageSize(cropedImage, targetSize: 5) {
                return cropedImage.jpegData(compressionQuality: 1.0)
            } else if let cropedImage = cropedImage {
                return sizeManager.compressImage(image: cropedImage, to: .small(size: 5))
            }
        }
        return nil
    }
    
    // API Call
    @MainActor
    func signIn() async {
        if validate().first(where: { $0.state == .error }) != nil {
            return
        } else if let imageData = compessImageIfNeed(),
                  let positionId = selectedPosition?.id {
            
            do {
                if try await TokenEndpointType().loadToken() == true {
                    let result = try await signInEndpoint.signIn(name: name.title,
                                                                 email: email.title,
                                                                 phone: phone.title,
                                                                 positionID: positionId,
                                                                 photoData: imageData)
                    self.signInResult.status = .registared
                    self.signInResult.isPresented = true
                }
            } catch let error {
                DispatchQueue.main.async {
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .parsing(description: let description):
                            self.signInResult.status = .error(description.localizedDescription)
                        case .sending:
                            self.signInResult.status = .error("Unrecognized error")
                        case .error(networkError: _):
                            self.signInResult.status = .error("Some network problem")
                        case .errorString(description: let descriptionStr):
                            self.signInResult.status = .error(descriptionStr)
                        case .unexpected(code: _):
                            self.signInResult.status = .error("Unrecognized error")
                        }
                    }
                    self.signInResult.isPresented = true
                }
            }
        }
    }
    
    @MainActor
    func fetchPositions() async {
        isLoading = true
        
        let result = await positionEndpoint.fetchPositionList()
        switch result {
        case .success(let list):
            self.positions = list
        case .failure(let error):
            print("error: \(error)")
        }
        self.isLoading = false
    }
    
}
