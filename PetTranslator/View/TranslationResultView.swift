//
//  TranslationResultView.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 08/02/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct TranslationResultView: View {
    @EnvironmentObject var vm: ContentVM
    @EnvironmentObject var recorder: AudioRecorderVM
    @Binding var path: NavigationPath
    @State private var isProcessing = true
    @State private var isRepeat = false
   
    var body: some View {
        if isProcessing {
            ProcessingView(path: $path, isClicker: $vm.isClicker, isDog: vm.isDog)
                .onAppear {
                    startFakeNetworkCall()
                }
        } else {
            VStack {
                VStack {
                    ZStack {
                        BackButtonView {
                            path.removeLast()
                        }
                        Text("Result")
                            .customFontStyle(size: 32)
                    }
                    .frame(width: 350, height: 58, alignment: .center)
                    Spacer()
                    Group {
                        if isRepeat {
                            Spacer()
                            RepeatView()
                                .onTapGesture {
                                    isRepeat.toggle()
                                }
                        } else {
                            if vm.isTranslatingToPet {
                                AnimatedImage(name: "recording.gif", isAnimating: $recorder.isPlaying)
                                    .frame(width: 163, height: 120)
                                    .onAppear {
                                        recorder.playAudio(filename: vm.isDog ? "dog-bark-1" : "cat-meow-2", fileExtension: "mp3")
                                    }
                                    .onDisappear {
                                        recorder.stopPlayback()
                                    }
                            } else {
                                ZStack {
                                    SpeechBubbleView()
                                    if vm.isDog {
                                        Text("What are you doing, human?")
                                            .customFontStyle(size: 12)
                                    } else {
                                        Text("I'm hungry, feed me!")
                                            .customFontStyle(size: 12)
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        recorder.stopPlayback()
                        print("Show Repeat")
                        isRepeat.toggle()
                    }
                    Spacer()
                }
                .frame(height: 353)
                Spacer()
                PetImageView(pet: vm.isDog ? "dog-big" : "cat-big")
                Spacer()
                Rectangle().frame(height: 82).opacity(0)
            }
            .customBackgroundStyle()
        }
    }
    
    
    func startFakeNetworkCall() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
        }
    }
}

struct RepeatView: View {
    var body: some View {
        ZStack {
            CustomRoundedRectangleView(color: "custom-grey")
            Label {
                Text("Repeat")
                    .customFontStyle(size: 12)
            } icon: {
                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                    .foregroundStyle(Color("text"))
                    .imageScale(.small)
            }
        }
        .frame(width: 291, height: 54)
    }
}

struct BackButtonView: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image("close")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            Spacer()
        }
    }
}

#Preview {
    TranslationResultView(path: .constant(NavigationPath()))
        .environmentObject(ContentVM())
        .environmentObject(AudioRecorderVM())
}

#Preview("Repeat") {
    RepeatView()
}

#Preview("Back") {
    BackButtonView {
        print("Button was tapped!")
    }
}
