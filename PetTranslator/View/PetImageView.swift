//
//  PetImageView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct PetImageView: View {
    let pet: String
    
    var body: some View {
        Image(pet)
            .resizable()
            .frame(width: 184, height: 184)
    }
}

#Preview {
    PetImageView(pet: "dog-big")
}
