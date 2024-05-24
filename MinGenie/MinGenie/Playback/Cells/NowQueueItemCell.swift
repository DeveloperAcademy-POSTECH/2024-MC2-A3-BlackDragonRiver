import MusicKit
import SwiftUI

/// A view that displays information about a music item.
struct NowQueueItemCell: View {
    // MARK: - Properties
    private var artworkSize: CGFloat = 51
    private var artworkCornerRadius: CGFloat = 11
    private var subtitleVerticalOffset: CGFloat = -8
    
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
                ZStack {
                    Rectangle()
                        .frame(width: artworkSize, height: artworkSize)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                }
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
            .foregroundColor(Color("text/Black"))
            
            
            Spacer() // 왼쪽에 빈 공간 추가
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("bg/Main"))
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
