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
    // MARK: - Constants
    private static let defaultArtworkSize = 44.0
    private static let defaultArtworkCornerRadius = 4.0
    
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
    
    // MARK: - Properties
    
    let artwork: Artwork?
    let title: String
    let subtitle: String
    
    var artworkSize: CGFloat = defaultArtworkSize
    var artworkCornerRadius: CGFloat = defaultArtworkCornerRadius
    var subtitleVerticalOffset: CGFloat = -4
    
    // MARK: - View
    
    var body: some View {
        HStack {
            if let itemArtwork = artwork {
                imageContainer(for: itemArtwork)
                    .frame(width: artworkSize, height: artworkSize)
            }else{
                ZStack{
                    Rectangle()
                        .frame(width: artworkSize, height: artworkSize)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                }
                
            }
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size:17,weight:.regular))
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .font(.system(size:13,weight:.regular))
                        .padding(.top, (-2.0 + subtitleVerticalOffset))
                }
            }.padding(.leading, 12)

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
