//
//  AuthView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/16/24.
//

import MusicKit
import SwiftUI

// 애플 뮤직 권한 받기 View
struct AuthView: View {
    @Binding var musicAuthorizationStatus: MusicAuthorization.Status
    @Environment(\.openURL) private var openURL
    @State private var musicSubscription: MusicSubscription?

    var body: some View {
        VStack {
            if musicAuthorizationStatus == .notDetermined || musicAuthorizationStatus == .denied {
                Button(action: handleButtonPressed) {
                    Text("\(musicAuthorizationStatus)")
                        .padding([.leading, .trailing], 10)
                }
                Text("\(String(describing: musicSubscription))")
            }
        }
    }
    
    private func handleButtonPressed() {
        switch musicAuthorizationStatus {
            case .notDetermined:
                Task {
                    let musicAuthorizationStatus = await MusicAuthorization.request()
                    await update(with: musicAuthorizationStatus)
                    print(musicAuthorizationStatus)
                }
            case .denied:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    openURL(settingsURL)
                }
            default:
                fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
        }
    }
    
    /// Safely updates the `musicAuthorizationStatus` property on the main thread.
    @MainActor
    private func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        withAnimation {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }
}

#Preview {
    AuthView(musicAuthorizationStatus: .constant(.notDetermined))
}
