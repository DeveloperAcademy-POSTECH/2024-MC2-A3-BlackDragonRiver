//
//  MusicSearchView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/20/24.
//

import MusicKit
import SwiftUI

struct MusicSearchView: View {
    @ObservedObject private var model = MusicSearchModel()
    
    @State private var searchTerm: String = ""
    @State private var selectedCategory: Category = .song
    
    var body: some View {
        NavigationView {
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
            .searchable(text: $searchTerm, prompt: "아티스트, 노래")
        }
        .onChange(of: searchTerm, { _, _ in
            model.requestUpdatedSearchResults(for: searchTerm)
        })
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
                .fill(selectedCategory == category ? .blue : .gray) // color 수정
                .frame(width: 54, height: 33)
                .overlay {
                    Text(category.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(selectedCategory == category ? .white : .gray) // color 수정
                }
        }
    }
}

struct SongResultRowView: View {
    let song: Song
    
    var body: some View {
        Button {
            /* 240520 Yu:D
             노래 재생 로직 추가해야 함.
             */
            print("노래 재생")
        } label: {
            HStack {
                if let artwork = song.artwork {
                    ArtworkImage(artwork, width: 44, height: 44)
                        .scaledToFill()
                        .cornerRadius(11)
                }
                
                VStack(alignment: .leading) {
                    Text("\(song.title)")
                        .font(.system(size: 17))
                        .foregroundStyle(.black) // color 수정
                    
                    Text("\(song.artistName)")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary) // color 수정
                    
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
    
    var body: some View {
        NavigationLink {
//            AlbumDetailView(album: album)
        } label: {
            HStack {
                if let artwork = album.artwork {
                    ArtworkImage(artwork, width: 44, height: 44)
                        .scaledToFill()
                        .cornerRadius(11)
                }
                
                VStack(alignment: .leading) {
                    Text("\(album.title)")
                        .font(.system(size: 17))
                        .lineLimit(1)
                        .foregroundStyle(.black) // color 수정
                    
                    HStack {
                        Text("\(album.artistName)")
                        
                        Text("・")
                        
                        if let releaseDate = album.releaseDate {
                            Text("\(releaseDate, style: .date)")
                        }
                    }
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary) // color 수정
                    
                    Divider()
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 9)
        }
    }
}

#Preview {
    MusicSearchView()
}
