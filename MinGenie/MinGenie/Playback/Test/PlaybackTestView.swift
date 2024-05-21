//
//  PlaybackTestView.swift
//  MinGenie
//
//  Created by dora on 5/20/24.
//

/// ❌ 작동 확인용 View입니다 ❌

import MusicKit
import SwiftUI

struct PlaybackView: View {
    var body: some View {
        ZStack{
            SearchView()
            
            VStack{
                Spacer()
                MiniPlayerView(isShowingNowPlaying: false)
                    .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    PlaybackView()
}
