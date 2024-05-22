//
//  MusicItemCell.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import MusicKit
import SwiftUI

/// 해당 View를 그리기 위해서는 Track 타입 값을 넣어 주어야 합니다.
struct MusicItemCell: View {
    let track: Track
    let imageSize: CGFloat
    
    private let imageCornerRadius: CGFloat = 20
    private let imageOpacity = 0.7
    
    private var title: String {
        return track.title
    }
    private var artistName: String {
        return track.artistName
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Button {
                // 이후에 해당 노래를 틀어주는 로직 추가 🐯
                print("이 노래 틀어 🎧")
            } label: {
                if let artwort = track.artwork {
                    
                    ArtworkImage(artwort, width: imageSize, height: imageSize)
                        .aspectRatio(contentMode: .fill)
                        .overlay(
                            LinearGradient(colors: [.clear, .black],
                                           startPoint: .top,
                                           endPoint: .bottom
                                          )
                            .opacity(imageOpacity)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: imageCornerRadius))
                    
                } else {  // Track에 이미지가 없을 경우 예외 처리
                    Image("")
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
            }
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(title)
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text(artistName)
                            .foregroundStyle(.white)
                            .font(.subheadline)
                    }
                    .lineLimit(1)
                    .padding(10)
                    
                    Spacer()
                }
                
            }
            
        }
    }
}

//#Preview {
//    MusicItemCell(imageSize: 160)
//}
