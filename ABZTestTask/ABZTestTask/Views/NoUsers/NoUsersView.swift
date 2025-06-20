//
//  NoUsersView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import SwiftUI

struct NoUsersView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image("NoUsers")
            Text("There are no users yet")
                .font(.system(size: 20))
        }
    }
}

#Preview {
    NoUsersView()
}
