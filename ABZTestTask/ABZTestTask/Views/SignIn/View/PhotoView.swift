//
//  PhotoView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 14.06.2025.
//

import SwiftUI

struct PhotoView: View {
    var image: UIImage?
    let text: String
    @Binding var state: FieldState
    @Binding var infoText: String
    var action: ()->()
    
    var body: some View {
        VStack {
            HStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text(text)
                Spacer()
                Button("Upload") {
                    action()
                }.tint(.secondary)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(state.color())
            }.onTapGesture {
                action()
            }
            
            if !infoText.isEmpty {
                HStack {
                    Text(infoText)
                        .foregroundStyle(state.textColor())
                        .padding(.leading, 10)
                        .frame(height: 16)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var state: FieldState = .normal
    @Previewable @State var infoText: String = ""
    PhotoView(text: "Upload photo",
              state: $state,
              infoText: $infoText,
              action: {})
}
