//
//  FooterTabView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 08/02/2025.
//

import SwiftUI

struct FooterTabView: View {
    @Binding var path: NavigationPath
    @Binding var isClicker: Bool
    
    var body: some View {
        ZStack {
            CustomRoundedRectangleView(color: "s-white")
            HStack {
                FooterItemView(isClicker: isClicker, image: "messages-2", label: "Translator")
                .onTapGesture {
                    path = NavigationPath()
                    isClicker = false
                }
                FooterItemView(isClicker: !isClicker, image: "sys-settings", label: "Clicker")
                .onTapGesture {
                    if !isClicker {
                        path.append("Settings")
                        isClicker = true
                    }
                }
            }
        }
        .frame(width: 216, height: 82)
    }
}

struct FooterItemView: View {
    var isClicker: Bool
    let image: String
    let label: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
            Text(label)
                .customFontStyle(size: 12)
        }
        .opacity(isClicker ? 0.5 : 1)
        .padding()
    }
}

#Preview {
    FooterTabView(path: .constant(NavigationPath()), isClicker: .constant(false))
}
