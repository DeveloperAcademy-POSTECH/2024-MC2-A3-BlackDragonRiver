//
//  ContentView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//


import MusicKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var phase
    
    @StateObject private var shakeDetectionModel = ShakeDetectionModel()
    @StateObject var musicPlayerModel = MusicPlayerModel.shared
    
    @State private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            ZStack(alignment: .bottom) {
                HomeView()
                    .modelContainer(for: StoredTrackID.self)
                    .environmentObject(musicPlayerModel)
                
                    .onChange(of: phase) { _, newValue in
                        if newValue == .background {
                            shakeDetectionModel.startDetection()
                        } else {
                            shakeDetectionModel.stopDetection()
                        }
                    }
                    .onChange(of: shakeDetectionModel.shakeDetected) { _, newValue in
                        if newValue && musicPlayerModel.isPlaying {
                            print("🎧 Music Change")
                            
                            // 노래 교체가 끝나면 다시 시작
                            shakeDetectionModel.stopDetection()
                            Task {
                                await musicPlayerModel.playRandomMusic()
                                if phase == .background {
                                    shakeDetectionModel.startDetection()
                                }
                            }
                        }
                    }
                
                MiniPlayerView()
            }
            .ignoresSafeArea(.keyboard)
        } else {
            OnboardingTabView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}


#Preview {
    ContentView()
}
