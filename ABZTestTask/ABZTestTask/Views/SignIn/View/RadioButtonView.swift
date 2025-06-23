//
//  RedioButtonView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 14.06.2025.
//

import SwiftUI

struct RadioButtonView: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Button("", image: isSelected ? .resource("RedioBtnSelected") : .resource("RedioBtnNormal")) {
                isSelected.toggle()
            }
            
            Text(title).foregroundStyle(Color.black87Color).font(.system(size: 16))
            Spacer()
        }.onTapGesture {
            isSelected.toggle()
        }
    }
}

#Preview {
    @Previewable @State var isSelected: Bool = false
    RadioButtonView(title: "Text", isSelected: $isSelected)
}
