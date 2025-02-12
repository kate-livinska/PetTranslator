//
//  ProcessingView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct ProcessingView: View {
    @Binding var path: NavigationPath
    @Binding var isClicker: Bool
    let isDog: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Process of translation...")
                .customFontStyle(size: 16)
                .frame(height: 290, alignment: .bottom)
            Spacer()
            PetImageView(pet: isDog ? "dog-big" : "cat-big")
            Spacer()
            FooterTabView(path: $path, isClicker: $isClicker)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color("gradient-top"), Color("gradient-bottom")]), startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    ProcessingView(path: .constant(NavigationPath()), isClicker: .constant(false), isDog: true)
}
