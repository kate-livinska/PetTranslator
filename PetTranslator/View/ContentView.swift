//
//  ContentView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 06/02/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @State var path = NavigationPath()
    @StateObject private var recorder = AudioRecorderVM()
    @StateObject private var vm = ContentVM()
    @State private var isAlertPresented = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack {
                    Text("Translator")
                        .customFontStyle(size: 32)
                        .frame(width: 350, height: 58)
                    TranslationDirectionView(isTranslatingToPet: $vm.isTranslatingToPet)
                        .padding()
                        .onTapGesture {
                            if !recorder.isRecording {
                                vm.isTranslatingToPet.toggle()
                            }
                        }
                    HStack {
                        RecordingView(isRecording: recorder.isRecording)
                        .onTapGesture {
                            if recorder.needToEnableMicrophoneAccess {
                                isAlertPresented = true
                            } else {
                                if !recorder.isRecording {
                                    recorder.startRecording()
                                } else {
                                    path.append("Result")
                                    recorder.stopRecording()
                                    //not processing recording in the test assignment, so deleting it at once
                                    recorder.deleteRecording()
                                }
                            }
                        }
                        Spacer()
                        ZStack {
                            CustomRoundedRectangleView(color: "s-white")
                            VStack {
                                CatDogSideView(isDog: !vm.isDog, image: "cat-small")
                                    .onTapGesture {
                                        if !recorder.isRecording {
                                            vm.isDog = false
                                        }
                                    }
                                CatDogSideView(isDog: vm.isDog, image: "dog-small")
                                    .onTapGesture {
                                        if !recorder.isRecording {
                                            vm.isDog = true
                                        }
                                    }
                            }
                        }
                        .frame(width: 107, height: 176)
                    }
                    .frame(width: 320, height: 176)
                    .padding()
                }
                .frame(height: 400)
                Spacer()
                PetImageView(pet: vm.isDog ? "dog-big" : "cat-big")
                Spacer()
                FooterTabView(path: $path, isClicker: $vm.isClicker)
            }
            .customBackgroundStyle()
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "Result":
                    TranslationResultView(path: $path)
                        .environmentObject(vm)
                        .environmentObject(recorder)
                        .navigationBarBackButtonHidden()
                case "Settings":
                    SettingsView(path: $path)
                        .environmentObject(vm)
                        .navigationBarBackButtonHidden()
                default:
                    ContentView()
                }
            }
            .alert("Enable Microphone Access", isPresented: $isAlertPresented) {
                Button("Cancel", role: .cancel) {
                }
                Button("Settings") {
                    openSettings()
                }
            } message: {
                Text("Please allow access to your mircophone to use the app’s features")
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
    }
}

struct TranslationDirectionView: View {
    @Binding var isTranslatingToPet: Bool
    
    var body: some View {
        HStack {
            Text(isTranslatingToPet ? "HUMAN" : "PET")
                .customFontStyle(size: 16)
            .frame(width: 135, height: 61)
            Image("arrow-swap-horizontal")
                .resizable()
                .frame(width: 24, height: 24)
            Text(isTranslatingToPet ? "PET" : "HUMAN")
                .customFontStyle(size: 16)
            .frame(width: 135, height: 61)
        }
        .frame(width: 310, height: 61)
        }
    }


struct RecordingView: View {
    var isRecording: Bool
    
    var body: some View {
        ZStack {
            CustomRoundedRectangleView(color: "s-white")
            VStack {
                if isRecording {
                    AnimatedImage(name: "recording.gif", isAnimating: .constant(true))
                        .frame(width: 163, height: 95)
                    Text("Recording...")
                        .customFontStyle(size: 16)
                } else {
                    Image("microphone2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding()
                    Text("Start Speak")
                        .customFontStyle(size: 16)
                }
            }
        }
        .frame(width: 178, height: 176)
    }
}

struct CatDogSideView: View {
    var isDog: Bool
    let image: String
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 70, height: 70)
            .opacity(isDog ? 1 : 0.5)
    }
}

#Preview {
    ContentView()
}

#Preview("GIF") {
    RecordingView(isRecording: true)
}
