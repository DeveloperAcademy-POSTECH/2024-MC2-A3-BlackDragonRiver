import MusicKit
import SwiftUI

/// A view that displays information about a music item.
struct NowQueueItemCell: View {
    // MARK: - Properties
    private let artworkSize: CGFloat = 51
    private let artworkCornerRadius: CGFloat = 11
    private let subtitleVerticalOffset: CGFloat = -8
    
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
            if let itemArtwork = artwork {
                imageContainer(for: itemArtwork)
                    .frame(width: artworkSize, height: artworkSize)
            } else {
                    Image("FlowishGray")
                        .resizable()
                        .frame(width: artworkSize, height: artworkSize)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .regular))
                        .padding(.top, subtitleVerticalOffset)
                }
            }
            .padding(.leading, 8)
            .lineLimit(1)
            .foregroundColor(Color.Text.black)
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: 62, alignment: .leading)
        .background(Color.BG.main)
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

