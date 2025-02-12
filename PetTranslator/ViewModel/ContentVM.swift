//
//  ContentVM.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 10/02/2025.
//

import SwiftUI

class ContentVM: ObservableObject {
    @Published var isTranslatingToPet = false
    @Published var isDog = true
    @Published var isClicker = false
}
