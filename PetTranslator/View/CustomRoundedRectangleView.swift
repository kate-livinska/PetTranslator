//
//  CustomRoundedRectangleView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct CustomRoundedRectangleView: View {
    let color: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(color))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.25), radius: 5, x: 0, y: 4)
    }
}

#Preview {
    CustomRoundedRectangleView(color: "white")
}
