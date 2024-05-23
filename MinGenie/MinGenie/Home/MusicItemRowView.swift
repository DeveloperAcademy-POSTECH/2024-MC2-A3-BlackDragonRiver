//
//  MusicItemRowView.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//


import MusicKit
import SwiftUI

struct MusicItemRowView: View {
    private let imageSize: CGFloat = 160
    
    let itemRowTitle: String
    let tracks: MusicItemCollection<Track>
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(itemRowTitle)
                .font(.headline)
                .foregroundStyle(Color.Text.blue)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(tracks, id: \.self) { track in
                        MusicItemCell(track: track, imageSize: imageSize)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: imageSize)
        }
        
    }
}

