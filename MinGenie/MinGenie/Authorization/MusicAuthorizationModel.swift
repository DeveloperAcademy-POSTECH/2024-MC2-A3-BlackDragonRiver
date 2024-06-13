//
//  MusicAuthorizationModel.swift
//  MinGenie
//
//  Created by 김유빈 on 5/17/24.
//

import MusicKit
import SwiftUI

/// 애플 뮤직 권한 받기 Model
final class MusicAuthorizationModel: ObservableObject {
    @State private var musicAuthorizationStatus: MusicAuthorization.Status = .notDetermined
    @Environment(\.openURL) private var openURL

    /// 애플 뮤직 접근 권한 요청
    func requestMusicAuthorizationStatus(currentPage: Binding<Int>) {
        Task {
            let musicAuthorizationStatus = await MusicAuthorization.request()
            await update(with: musicAuthorizationStatus)
            handleAuthorizationStatus(musicAuthorizationStatus, currentPage: currentPage)
        }
    }
    
    /// 권한 상태에 따른 처리
    private func handleAuthorizationStatus(_ status: MusicAuthorization.Status, currentPage: Binding<Int>) {
        switch status {
        case .authorized:
            currentPage.wrappedValue = 2
        case .denied, .restricted:
            openSettings()
        case .notDetermined:
            break
        @unknown default:
            fatalError("Unexpected authorization status: \(status)")
        }
    }
    
    /// 앱이 포그라운드로 돌아왔을 때 권한 상태를 재확인
     func checkMusicAuthorizationStatus(currentPage: Binding<Int>) {
         let status = MusicAuthorization.currentStatus
         handleAuthorizationStatus(status, currentPage: currentPage)
     }

    @MainActor
    func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        withAnimation {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }

    /// 애플 뮤직 권한 읽기
    func readMusicAccessStatus() -> MusicAuthorization.Status {
        return self.musicAuthorizationStatus
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}
