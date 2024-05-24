//
//  ContentView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//

import AudioToolbox
import MusicKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var phase

    @StateObject private var shakeDetectionModel = ShakeDetectionModel()
    @StateObject var musicPlayerModel = MusicPlayerModel()
    
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        if hasSeenOnboarding {
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
                        
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //진동 주기
                        
                        Task {
                           await musicPlayerModel.playRandomMusic()
                            shakeDetectionModel.markActionCompleted()
                        }
                    }
                }

        } else {
            OnboardingTabView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}


#Preview {
    ContentView()
}
