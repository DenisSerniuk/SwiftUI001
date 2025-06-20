//
//  RadioListView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 14.06.2025.
//

import SwiftUI

struct RadioListView: View {
    
    let title: String
    let list: [PositionModel]
    @Binding var selectedValue: PositionModel?
    @State private var isSelected: Bool = false
    var body: some View {
        VStack {
            
            HStack {
                Text(title)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.black87Color)
                Spacer()
            }
            
            ForEach(list, id: \.self) { content in
                RadioButtonView(title: content.name, isSelected: Binding(get: {
                    if let value = selectedValue, value.id == content.id {
                        return true
                    } else {
                        return false
                    }
                }, set: {
                    selectedValue = content
                    isSelected = $0
                })).padding(8)
            }
            Spacer()
        }
    }
    
    
}

#Preview {
    @State var selectedValue: PositionModel?
    RadioListView(title: "Select your position",
                  list: [PositionModel(id: 1, name: "Layer"),
                         PositionModel(id: 2, name: "Backend developer")],
                  selectedValue: $selectedValue)
}
