//
//  MusicItemCell.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import SwiftUI

struct MusicItemCell: View {
    let imageSize: CGFloat
    private let imageCornerRadius: CGFloat = 20
    private let imageOpacity = 0.7
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Button {
                // 이후에 해당 노래를 틀어주는 로직 추가 🐯
                print("이 노래 틀어 🎧")
            } label: {
                Image("new")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .overlay(
                        LinearGradient(colors: [.clear, .black],
                                       startPoint: .top,
                                       endPoint: .bottom
                                      )
                        .opacity(imageOpacity)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: imageCornerRadius))
            }
            
            VStack(alignment: .leading) {
                Text("Attention")
                    .foregroundStyle(.white)
                    .font(.headline)
                Text("가수")
                    .foregroundStyle(.white)
                    .font(.subheadline)
            }
            .padding(10)
        }
    }
}

#Preview {
    MusicItemCell(imageSize: 160)
}
