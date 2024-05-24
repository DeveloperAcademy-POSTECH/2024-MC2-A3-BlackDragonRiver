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
    @StateObject var musicPlayerModel = MusicPlayerModel()
    
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        if hasSeenOnboarding {
            HomeView()
                .modelContainer(for: StoredTrackID.self)
                .environmentObject(musicPlayerModel)
//                .onChange(of: phase) { _, newValue in
//                    if newValue == .background {
//                        print("START DETECTION❗️")
//                        shakeDetectionModel.startDetection()
//                    } else {
//                        print("🚫: \(phase)")
//                        print(shakeDetectionModel.stopDetection())
//                    }
//                }
//                .onChange(of: shakeDetectionModel.shakeDetected) { _, newValue in
//                    if newValue && musicModel.isPlaying {
//                        print("🎧 Music Change")
//                        // 노래 교체가 끝나면 다시 시작
//                        Task {
//                           await musicModel.playRandomMusic()
//                            shakeDetectionModel.markActionCompleted()
//                        }
//                    }
//                }

        } else {
            OnboardingTabView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}


#Preview {
    ContentView()
}
