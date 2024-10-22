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
    @EnvironmentObject var musicPlayerModel: MusicPlayerModel
    
    @State private var isPlaying = false
    
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
                .foregroundStyle(Color.BG.main)
            
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
                    isPlaying.toggle()
                    
                    if let tracks = model.tracks {
                        musicPlayerModel.playAlbumWithRecommendedList(tracks, album: album)
                    }
                } label: {
                    Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                        .resizable()
                        .frame(width: 46, height: 46)
                        .foregroundStyle(Color.Shape.blue)
                }
                .disabled(isPlaying)
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
        .background(Color.BG.main)
        .lineLimit(1)
        .ignoresSafeArea(edges: .top)
        .navigationTitle(album.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            try? await model.loadTracks(album: album)
        }
    }
}

struct MusicListRowView: View {
    @EnvironmentObject var musicPlayerModel: MusicPlayerModel
    
    let track: Track
    
    var body: some View {
        Button {
            if case .song(let song) = track {
                musicPlayerModel.playMusicWithRecommendedList(song)
            }
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
