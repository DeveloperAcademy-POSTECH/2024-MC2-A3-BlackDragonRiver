//
//  SongCell.swift
//  MinGenie
//
//  Created by 김유빈 on 5/23/24.
//

import MusicKit
import SwiftUI

struct SongCell: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var musicPlayerModel: MusicPlayerModel
        
    private let artworkSize: CGFloat = 44
    let song: Song
    
    var body: some View {
        Button {
            musicPlayerModel.playMusicWithRecommendedList(song)
            modelContext.insert(StoredTrackID(song))
        } label: {
            HStack {
                if let artwork = song.artwork {
                    ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                        .scaledToFill()
                        .cornerRadius(11)
                }
                
                VStack(alignment: .leading) {
                    Text("\(song.title)")
                        .font(.body)
                        .foregroundStyle(Color.Text.black)

                    Text("\(song.artistName)")
                        .font(.subheadline)
                        .foregroundStyle(Color.Text.gray60)

                    Divider()
                }
                .lineLimit(1)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 9)
        }
    }
}
