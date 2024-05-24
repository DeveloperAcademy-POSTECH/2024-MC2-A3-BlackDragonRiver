//
//  MinGenieApp.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//

import SwiftData
import SwiftUI

@main
struct MinGenieApp: App {
    @Environment(\.scenePhase) var phase
    
    @StateObject private var shakeDetectionModel = ShakeDetectionModel()
    @StateObject private var musicModel = MusicPlayerModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: StoredTrackID.self)
                .onChange(of: phase) { _, newValue in
                    if newValue == .background {
                        print("START DETECTION❗️")
                        shakeDetectionModel.startDetection()
                    } else {
                        print("🚫: \(phase)")
                        print(shakeDetectionModel.stopDetection())
                    }
                }
                .onChange(of: shakeDetectionModel.shakeDetected) { _, newValue in
                    if newValue && musicModel.isPlaying {
                        print("🎧 Music Change")
                        // 노래 교체가 끝나면 다시 시작
                        Task {
                           await musicModel.playRandomMusic()
                            shakeDetectionModel.markActionCompleted()
                        }
                    }
                }
        }
    }
}
