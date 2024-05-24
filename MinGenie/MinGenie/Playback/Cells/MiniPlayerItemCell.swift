/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A cell that displays information about a music item.
 */

/// ✏️ MiniPlayer 곡 표시 cell ✏️


import MusicKit
import SwiftUI

/// A view that displays information about a music item.
struct MiniPlayerItemCell: View {
    // MARK: - Properties
    private var artworkSize: CGFloat = 44
    private var artworkCornerRadius: CGFloat = 4
    private var subtitleVerticalOffset: CGFloat = -10
    
    let artwork: Artwork?
    let title: String
    let subtitle: String
    
    // MARK: - Initialization
    
    init(
        artwork: Artwork? = nil,
        title: String,
        subtitle: String? = nil
    ) {
        self.artwork = artwork
        self.title = title
        self.subtitle = (subtitle ?? "")
    }
    
    // MARK: - View
    var body: some View {
        HStack {
            VStack{if let itemArtwork = artwork {
                imageContainer(for: itemArtwork)
                    .frame(width: artworkSize, height: artworkSize)
                    .padding(.horizontal,8)
            } else {
                ZStack {
                    Rectangle()
                        .frame(width: artworkSize, height: artworkSize)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                }
            }
            }
            
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.Text.white100)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.Text.white60)
                        .padding(.top, subtitleVerticalOffset)
                }
            }
            .padding(.horizontal, -6)
            .lineLimit(1)
            .foregroundColor(Color.Text.white60)
        }
    }
    
    private func imageContainer(for artwork: Artwork) -> some View {
        VStack {
            Spacer()
            ArtworkImage(artwork, width: artworkSize, height: artworkSize)
                .cornerRadius(artworkCornerRadius)
            Spacer()
        }
    }
}
