//
//  Test_PlaylistView.swift
//  MinGenie
//
//  Created by dora on 5/22/24.
//

import SwiftUI

struct Test_PlaylistView: View{
    @ObservedObject var musicPlayer = MusicPlayerModel()
    @ObservedObject var model = MusicPersonalRecommendationModel()
    
    var body: some View{
        ZStack{
            Circle()
                .frame(width: 250)
                .shadow(radius: 8)
            Text("플레이리스트 재생")
                .foregroundStyle(.white)
        }
        .onTapGesture {
            musicPlayer.play(model.tracks![0], in: model.tracks, with: nil)
        }
    }
}
