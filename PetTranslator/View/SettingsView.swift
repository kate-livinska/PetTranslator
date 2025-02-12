//
//  SettingsView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 08/02/2025.
//

import SwiftUI
import StoreKit

enum SettingsItems: Int, CaseIterable {
    case ContactUs = 0
    case RestorePurchases
    case Privacy
    case TermsOfUse
    
    var title: String {
        switch self {
        case .ContactUs:
            return "Contact Us"
        case .RestorePurchases:
            return "Restore Purchases"
        case .Privacy:
            return "Privacy Policy"
        case .TermsOfUse:
            return "Terms of Use"
        }
    }
    
    var url: URL {
        switch self {
        case .ContactUs:
            return URL(string: "https://echocode.app/#contacts")!
        case .RestorePurchases:
            return URL(string: "https://echocode.app/#prices")!
        case .Privacy:
            return URL(string: "https://www.figma.com/legal/privacy/")!
        case .TermsOfUse:
            return URL(string: "https://www.figma.com/legal/tos/")!
        }
    }
}

struct SettingsView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var vm: ContentVM
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        VStack {
            Text("Settings")
                .customFontStyle(size: 32)
                .frame(width: 350, height: 58)
            VStack {
                Button(action: {
                    requestReview()
                }, label: {
                    CustomButtonView(text: "Rate Us")
                })
                ShareLink(item: URL(string: "https://echocode.app/")!) { }
                    .buttonStyle(SettingsButtonStyle(text: "Share App"))
                ForEach(SettingsItems.allCases, id: \.self) { item in
                    Link(destination: item.url) {
                        CustomButtonView(text: item.title)
                    }
                }
            }
            .frame(width: 358, height: 370)
            .padding()
            Spacer()
            FooterTabView(path: $path, isClicker: $vm.isClicker)
        }
        .customBackgroundStyle()
    }
}

struct CustomButtonView: View {
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("custom-grey"))
            HStack {
                Text(text)
                    .customFontStyle(size: 16)
                    .padding(.leading)
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Color("text"))
                    .padding(.trailing)
            }
        }
        .frame(width: 358, height: 50)
    }
}

struct SettingsButtonStyle: ButtonStyle {
    var text: String

    func makeBody(configuration: Configuration) -> some View {
        CustomButtonView(text: text)
        .opacity(configuration.isPressed ? 0.5 : 1)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
        .animation(.spring(), value: configuration.isPressed)
    }
}


#Preview {
    SettingsView(path: .constant(NavigationPath()))
        .environmentObject(ContentVM())
}

#Preview("MenuItem") {
    CustomButtonView(text: "Rate Us")
}
