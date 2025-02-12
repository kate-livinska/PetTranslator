//
//  CustomBackGround.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct CustomBackGround: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("gradient-top"), Color("gradient-bottom")]), startPoint: .top, endPoint: .bottom)
            )
    }
}

extension View {
    func customBackgroundStyle() -> some View {
        modifier(CustomBackGround())
    }
}
