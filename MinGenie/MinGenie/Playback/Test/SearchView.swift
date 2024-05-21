//
//  SearchView.swift
//  MinGenie
//
//  Created by dora on 5/20/24.
//

/// ❌ 아직 HomeView와 연동하기 전이라 임의로 만들어둔 View입니다 ❌

import SwiftUI
import MusicKit

struct SearchView: View {
    @ObservedObject var searchModel = SearchModel()
    @ObservedObject var musicPlayer = MusicPlayerModel()

    var body: some View {
        VStack {
            Text("실리카겔 검색 결과")
                .font(.title3)
                .padding(.top)
            
            /// searchModel에서 가져온 song을 리스트로 띄워주는 view
            NavigationView {
                List(searchModel.songs) { song in
                    HStack {
                        AsyncImage(url: song.imageUrl)
                            .frame(width: 75, height: 75, alignment: .center)
                        VStack(alignment: .leading) {
                            Text(song.name)
                                .font(.title3)
                            Text(song.artist)
                                .font(.footnote)
                        }
                        .padding()
                    }
                    .onTapGesture {
                        /// searchView에서 눌러서 선택된 Song을 MusicPlayer에 넣기 위한 Converter
                        musicPlayer.convertToMusicPlayer(song.song)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
