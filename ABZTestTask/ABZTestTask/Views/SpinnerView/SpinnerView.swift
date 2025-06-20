//
//  SpinnerView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 16.06.2025.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .blue))
          .scaleEffect(2.0, anchor: .center)
    }
}

#Preview {
    SpinnerView()
}
