//
//  SpeechBubbleView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI

struct SpeechBubbleView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("custom-grey"))
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.25), radius: 5, x: 0, y: 4)
            Path(){
               xPath in
                  xPath.move(to: CGPoint(x: 290, y: 100))
                  xPath.addLine(to: CGPoint(x: 270, y: 100))
                  xPath.addLine(to: CGPoint(x: 190, y: 230))
            }.fill(Color("custom-grey"))
        }
        .frame(width: 291, height: 142)
    }
}

#Preview {
    SpeechBubbleView()
}
