//
//  MusicItemCell.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import MusicKit
import SwiftData
import SwiftUI

/// 해당 View를 그리기 위해서는 Track 타입 값을 넣어 주어야 합니다.
struct MusicItemCell: View {
    @ObservedObject private var model = MusicPlayerModel.shared
    @Environment(\.modelContext) var modelContext
    
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
                if case .song(let song) = track {
                    modelContext.insert(StoredTrackID(song))
                }
                
                model.play(track, in: nil, with: nil)
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
                            .foregroundStyle(Color.Text.white100)
                            .font(.headline)
                        Text(artistName)
                            .foregroundStyle(Color.Text.white80)
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
