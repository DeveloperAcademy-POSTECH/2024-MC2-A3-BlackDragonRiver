//
//  MusicAuthorizationView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/16/24.
//

import MusicKit
import SwiftUI

/// 애플 뮤직 권한 받기 View
struct MusicAuthorizationView: View {
    private var musicAuthModel = MusicAuthorizationModel(musicAuthorizationStatus: .notDetermined)

    var body: some View {
        VStack {
            if musicAuthModel.musicAuthorizationStatus == .notDetermined || musicAuthModel.musicAuthorizationStatus == .denied {
                Button(action: musicAuthModel.requestMusicAuthorizationStatus) {
                    Text("\(musicAuthModel.musicAuthorizationStatus)")
                        .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}

#Preview {
    MusicAuthorizationView()
}
