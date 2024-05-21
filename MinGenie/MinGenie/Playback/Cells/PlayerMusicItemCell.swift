/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A cell that displays information about a music item.
*/

/// ✏️ 가로 길쭉이 곡 표시 cell ✏️
///  ✅ 디자인 세부 조정 필요

import MusicKit
import SwiftUI

/// A view that displays information about a music item.
struct PlayerMusicItemCell: View {
    
    // MARK: - Properties 선언과 Initialization
    
    var artwork: Artwork? = nil
    var artworkSize: CGFloat = PlayerMusicItemCell.defaultArtworkSize
    var artworkCornerRadius: CGFloat = PlayerMusicItemCell.defaultArtworkCornerRadius
    var title: String = "Unknown Title"
    var subtitle: String = "Unknown Artist"
    var subtitleVerticalOffset: CGFloat = 0.0
    
    // MARK: - View
    
    var body: some View {
        HStack {
            if let itemArtwork = artwork {
                imageContainer(for: itemArtwork)
                    .frame(width: artworkSize, height: artworkSize)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
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
    
    // MARK: - Constants
    private static let defaultArtworkSize = 80.0
    private static let defaultArtworkCornerRadius = 6.0
}
