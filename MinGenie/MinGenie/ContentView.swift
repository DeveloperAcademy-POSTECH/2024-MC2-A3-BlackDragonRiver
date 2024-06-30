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
    
    @StateObject var shakeDetectionModel = ShakeDetectionModel()
    @StateObject var musicPlayerModel = MusicPlayerModel.shared
    
    @AppStorage("Onboarding") var hasSeenOnboarding = false
    @AppStorage("BackgroundInfo") var hasSeenBackgroundInfoView = false
    
    var body: some View {
        if hasSeenOnboarding {
            ZStack(alignment: .bottom) {
                HomeView()
                    .modelContainer(for: StoredTrackID.self)
                    .environmentObject(musicPlayerModel)
                    .onChange(of: phase) { _, newValue in
                        if newValue == .background && musicPlayerModel.isPlaying {
                            shakeDetectionModel.startDetection()
                        } else {
                            shakeDetectionModel.stopDetection()
                        }
                    }
                    .onChange(of: shakeDetectionModel.shakeDetected) { _, newValue in
                        if newValue && musicPlayerModel.isPlaying {
                            print("🎧 Music Change")
                            
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //진동 주기
                            
                            // 노래 교체가 끝나면 다시 시작
                            shakeDetectionModel.stopDetection()
                            Task {
                                await musicPlayerModel.updatePlaylistAfterShaking()
                                if phase == .background {
                                    shakeDetectionModel.startDetection()
                                }
                            }
                        }
                    }
                
                MiniPlayerView()
                
                // 백그라운드에서 실행됨을 알리는 설명 화면
                // 앱 설치하고 처음 진입했을 때만 뜨고 이후로 뜨지 않음.
                // 온보딩과 동일함.
                if !hasSeenBackgroundInfoView {
                    ZStack(alignment: .topTrailing) {
                        Image("BackgroundInfoView")
                            .resizable()
                            .ignoresSafeArea()
                        Button {
                            hasSeenBackgroundInfoView = true
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                                .padding(EdgeInsets(top: 60, leading: 0, bottom: 0, trailing: 10))
                        }
                    }
                }
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
