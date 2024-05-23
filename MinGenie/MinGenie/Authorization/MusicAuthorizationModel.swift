//
//  MusicAuthorizationModel.swift
//  MinGenie
//
//  Created by 김유빈 on 5/17/24.
//

import MusicKit
import SwiftUI

/// 애플 뮤직 권한 받기 Model
struct MusicAuthorizationModel {
    @State private var musicAuthorizationStatus: MusicAuthorization.Status = .notDetermined
    
    /// 애플 뮤직 접근 권한 요청
    func requestMusicAuthorizationStatus() {
        switch musicAuthorizationStatus {
            case .notDetermined:
                Task {
                    let musicAuthorizationStatus = await MusicAuthorization.request()
                    await update(with: musicAuthorizationStatus)
                    print(musicAuthorizationStatus)
                }
            case .denied:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    /* 240517 Yu:D
                     To Do
                     1. 사용자가 접근 권한 허용 안 함을 선택했을 때 로직
                     */
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
    }
    
    /// Safely updates the `musicAuthorizationStatus` property on the main thread.
    @MainActor
    func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        withAnimation {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }
    
    
    /// 애플 뮤직 권한 읽기
    /// - Returns: 사용자의 애플 뮤직 권한 상태
    func readMusicAccessStatus() -> MusicAuthorization.Status {
        return self.musicAuthorizationStatus
    }

}
