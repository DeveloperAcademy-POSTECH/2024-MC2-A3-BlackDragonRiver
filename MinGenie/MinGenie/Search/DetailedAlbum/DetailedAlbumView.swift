//
//  DetailedAlbumView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/22/24.
//

import MusicKit
import SwiftUI

struct DetailedAlbumView: View {
    @ObservedObject private var model = DetailedAlbumModel()
    @ObservedObject private var musicModel = MusicPlayerModel.shared
    
    let album: Album
    private let artworkSize: CGFloat = 146
    
    var body: some View {
        ScrollView {
            if let artwork = album.artwork {
                ArtworkImage(artwork, width: UIScreen.main.bounds.width, height: 240)
                    .blur(radius: 10)
                    .overlay {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(.black.opacity(0.3))
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                    }
            }
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: 120)
                .foregroundStyle(.white)
            
            HStack {
                if let artwork = album.artwork {
                    ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, -220)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(album.title)") // 앨범 타이틀
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .padding(.bottom, 16)
                    
                    Text("\(album.artistName)") // 아티스트 이름
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.bottom, 41)
                }
                .foregroundStyle(Color.Text.black)
                
                Spacer()
                
                Button {
                    /* 240520 Yu:D
                     앨범 재생 추가해야 함.
                     */
                    
                    if let tracks = model.tracks {
                        musicModel.play(tracks[0], in: tracks, with: nil)

                    }
                    
                    print("노래 재생")
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 46, height: 46)
                        .foregroundStyle(Color.Shape.blue)
                }
            }
            .padding(.top, -55)
            .padding(.horizontal, 16)
            
            if let tracks = model.tracks {
                ForEach(tracks) { track in
                    Divider()
                        .foregroundStyle(Color.Line.gray40)
                        .padding(.leading, 16)

                    MusicListRowView(track: track)
                }
            }
        }
        .lineLimit(1)
        .ignoresSafeArea(edges: .top)
        .task {
            try? await model.loadTracks(album: album)
        }
    }
}

struct MusicListRowView: View {
    @ObservedObject private var model = MusicPlayerModel.shared
    
    let track: Track
    
    var body: some View {
        Button {
            model.play(track, in: nil, with: nil)
        } label: {
            HStack(spacing: 0) {
                if let trackNumber = track.trackNumber {
                    Text("\(trackNumber). \(track.title)") // 트랙별 타이틀
                        .font(.body)
                        .foregroundStyle(Color.Text.black)
                }
                
                Spacer()
            }
            .padding(.vertical, 15)
            .padding(.leading, 16)
        }
    }
}
