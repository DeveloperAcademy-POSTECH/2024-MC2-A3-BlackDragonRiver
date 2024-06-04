//
//  AlbumCell.swift
//  MinGenie
//
//  Created by 김유빈 on 5/23/24.
//

import MusicKit
import SwiftUI

struct AlbumCell: View {
    let album: Album
    private let artworkSize: CGFloat = 44
    
    var body: some View {
        NavigationLink {
            DetailedAlbumView(album: album)
        } label: {
            HStack {
                if let artwork = album.artwork {
                    ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                        .scaledToFill()
                        .cornerRadius(11)
                }
                
                VStack(alignment: .leading) {
                    Text("\(album.title)")
                        .font(.body)
                        .foregroundStyle(Color.Text.black)
                    
                    HStack {
                        Text("\(album.artistName)")
                        
                        Text("・")
                        
                        if let releaseDate = album.releaseDate {
                            Text("\(releaseDate, style: .date)")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.Text.gray60)
                    
                    Divider()
                }
                .lineLimit(1)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.Text.gray40)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 9)
        }
    }
}
