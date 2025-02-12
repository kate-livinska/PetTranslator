//
//  CustomFont.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct CustomFont: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("KonkhmerSleokchher-Regular", size: size))
            .foregroundColor(Color("text"))
    }
}

extension View {
    func customFontStyle(size: CGFloat) -> some View {
        modifier(CustomFont(size: size))
    }
}
