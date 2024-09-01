//
//  ControlImageView.swift
//  Pinch
//
//  Created by Jigar Oza on 25/08/24.
//

import SwiftUI

struct ControlImageView: View {
    // Properties
    var icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

#Preview {
    ControlImageView(icon: "minus.magnifyingglass")
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        .padding()
}
