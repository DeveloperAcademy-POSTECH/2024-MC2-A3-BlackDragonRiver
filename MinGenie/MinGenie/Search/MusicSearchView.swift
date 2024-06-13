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
                        SongCell(song: song)
                    }
                case .album:
                    ForEach(model.albums, id: \.self) { album in
                        AlbumCell(album: album)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .background(Color.BG.main)
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
