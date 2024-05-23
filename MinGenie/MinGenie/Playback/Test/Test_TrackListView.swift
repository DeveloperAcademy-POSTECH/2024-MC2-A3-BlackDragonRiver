//import SwiftUI
//import MusicKit
//
//struct TrackListView: View {
//    @ObservedObject var model = MusicPersonalRecommendationModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let tracks = model.tracks {
//                    List(tracks) { track in
//                        TrackRow(track: track)
//                    }
//                    .listStyle(.plain)
//                } else {
//                    Text("Loading...")
//                }a
//            }
//        }
//    }
//}
//
//struct TrackRow: View {
//    let track: Track
//
//    var body: some View {
//        HStack {
//            if let artwork = track.artwork {
//                ArtworkView(artwork: artwork)
//                    .frame(width: 50, height: 50)
//            }
//            VStack(alignment: .leading) {
//                Text(track.title)
//                    .font(.headline)
//                Text(track.artistName)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//struct ArtworkView: View {
//    let artwork: Artwork
//
//    var body: some View {
//        if let url = artwork.url(width: 50, height: 50) {
//            AsyncImage(url: url) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//            } placeholder: {
//                Color.gray.opacity(0.3)
//            }
//        } else {
//            Color.gray.opacity(0.3)
//        }
//    }
//}
