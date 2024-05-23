//
//  MusicSearchView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/20/24.
//

import MusicKit
import SwiftUI


struct MusicSearchView: View {
    @StateObject private var model = MusicSearchModel()
    
    @State private var selectedCategory: Category = .song
    @Binding var searchTerm: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if searchTerm != "" {
                HStack {
                    categoryButton(selectedCategory: $selectedCategory, category: .song)
                    
                    categoryButton(selectedCategory: $selectedCategory, category: .album)
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
            
            ScrollView {
                switch(selectedCategory) {
                case .song:
                    ForEach(model.songs, id: \.self) { song in
                        SongResultRowView(song: song)
                    }
                case .album:
                    ForEach(model.albums, id: \.self) { album in
                        AlbumResultRowView(album: album)
                    }
                }
            }
        }
        .onChange(of: searchTerm) { _, _ in
            model.requestUpdatedSearchResults(for: searchTerm)
        }
    }
}

struct categoryButton: View {
    @Binding var selectedCategory: Category
    let category: Category
    
    var body: some View {
        Button {
            selectedCategory = category
        } label: {
            RoundedRectangle(cornerRadius: 100)
                .fill(selectedCategory == category ? Color.Shape.blue : Color.Shape.gray10)
                .frame(width: 54, height: 33)
                .overlay {
                    Text(category.rawValue)
                        .font(.callout)
                        .foregroundColor(selectedCategory == category ? Color.Text.white100 : Color.Text.gray50)
                }
        }
    }
}

struct SongResultRowView: View {
    @ObservedObject private var model = MusicPlayerModel.shared
    @Environment(\.modelContext) var modelContext
    
    var mmm = NextMusicRecommendationModel()
    
    let song: Song
    private let artworkSize: CGFloat = 44
    
    var body: some View {
        Button {
            modelContext.insert(StoredTrackID(song))
            model.playMusicWithRecommendedList(song)
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

struct AlbumResultRowView: View {
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
