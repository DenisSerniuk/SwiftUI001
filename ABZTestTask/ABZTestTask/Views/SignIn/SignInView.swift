//
//  SignInView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 12.06.2025.
//

import SwiftUI

struct SignInView<Model>: View where Model: SignInViewModel {
    
    @StateObject var viewModel: Model
    @State private var isShowAlertPicker: Bool = false
    @State private var avatarImage: UIImage?
    @State private var isShowImagePicker: Bool = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .camera

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment:.leading, spacing: 24) {
                    VStack(spacing: 12) { // Good to change for viewModel.list .....
                        SignInFieldView(text: $viewModel.name.title,
                                        placeholder: viewModel.name.placeholder,
                                        infoText: $viewModel.name.info,
                                        state: $viewModel.name.state)
                        SignInFieldView(text: $viewModel.email.title,
                                        placeholder: viewModel.email.placeholder,
                                        infoText: $viewModel.email.info,
                                        state: $viewModel.email.state)
                        SignInFieldView(text: $viewModel.phone.title,
                                        placeholder: viewModel.phone.placeholder,
                                        infoText: $viewModel.phone.info,
                                        state: $viewModel.phone.state)
                    }

                    RadioListView(title: "Select your position",
                                  list: viewModel.positions,
                                  selectedValue: $viewModel.selectedPosition)
                    
                    PhotoView(image: viewModel.avatar.image,
                              text: "Upload photo",
                              state: $viewModel.avatar.state,
                              infoText: $viewModel.avatar.info,
                              action: {
                        isShowAlertPicker = true
                    }).frame(height: 56)
                                        
                    HStack {
                        Spacer()
                        Button("Sign Up") {
                            Task {
                                await viewModel.signIn()
                            }
                        }.padding()
                            .buttonStyle(AppButtonStyle())
                        Spacer()
                    }
                }
            }
            .actionSheet(isPresented: $isShowAlertPicker, content: {
                ActionSheet(title: Text("Choose how you want to add a photo"),
                            buttons: imagePickerButtons())
            })
            .sheet(isPresented: $isShowImagePicker, content: {
                ImagePickerView(selectedImage: $viewModel.avatar.image, sourceType: .photoLibrary)
            })
            .fullScreenCover(isPresented: $viewModel.signInResult.isPresented, content: {
                RegistrationStatusView(status: viewModel.signInResult.status) {
                    viewModel.signInResult.isPresented = false
                }
            })
            .padding(EdgeInsets(top: 32, leading: 16, bottom: 12, trailing: 16))
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Working with POST request")
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primary, for: .automatic)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .task {
                await viewModel.fetchPositions()
            }
            .overlay {
                if viewModel.isLoading {
                    SpinnerView()
                }
            }
        }
        
    }
    
    private func imagePickerButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [
            .default(Text("Camera"), action: {
                pickerSourceType = .camera
                isShowImagePicker = true
            }),
            .default(Text("Gallery"), action: {
                pickerSourceType = .photoLibrary
                isShowImagePicker = true
            }),
            .cancel(Text("Cancel"), action: {
                isShowAlertPicker = false
            })
        ]
        
        if avatarImage != nil {
            buttons.append(.destructive(Text("Delete image")))
        }
        
        return buttons
    }
}

#Preview {
    SignInView(viewModel: SignInViewModelType(signInEndpoint: SignInEndpointType(),
                                              positionEndpoint: LoadPositionEndpointType()))
}
