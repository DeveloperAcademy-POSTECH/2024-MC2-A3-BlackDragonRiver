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
    private var musicAuthModel = MusicAuthorizationModel()

    var body: some View {
        let musicAuthorizationStatus = musicAuthModel.readMusicAccessStatus()
        
        VStack {
            /* 240517 Yu:D
             View 구현 덜 했음. 수정해야 함.
             */
            if musicAuthorizationStatus == .notDetermined || musicAuthorizationStatus == .denied {
                Button(action: musicAuthModel.requestMusicAuthorizationStatus) {
                    Text("\(musicAuthorizationStatus)")
                        .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}

#Preview {
    MusicAuthorizationView()
}
