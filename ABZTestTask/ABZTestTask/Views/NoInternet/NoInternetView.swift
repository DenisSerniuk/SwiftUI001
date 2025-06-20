//
//  NoInternetView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import SwiftUI

struct NoInternetView: View {
    var update: ()->()?
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
            Image("NoInternet")
            Text("There is no internet connection")
                .font(.system(size: 20))
            Button("Try Again") {
                update()
            }.padding()
                .buttonStyle(AppButtonStyle())
            Spacer()
        }
    }
}

#Preview {
    NoInternetView(update: {})
}
