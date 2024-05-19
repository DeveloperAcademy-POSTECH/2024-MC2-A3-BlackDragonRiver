//
//  MusicItemRowView.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import SwiftUI

struct MusicItemRowView: View {
    private let sectionTitle = "지난 선곡"
    private let imageSize: CGFloat = 160
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(sectionTitle)
                .font(.headline)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(1...10, id: \.self) { _ in
                        MusicItemCell(imageSize: imageSize)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: imageSize)
        }
        
    }
}

#Preview {
    MusicItemRowView()
}
