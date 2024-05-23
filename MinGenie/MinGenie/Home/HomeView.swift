//
//  HomeView.swift
//  MinGenie
//
//  Created by 김하준 on 5/22/24.
//

import MusicKit
import SwiftUI

struct HomeView: View {
    @ObservedObject private var model = MusicPersonalRecommendationModel()
    @State private var searchTerm: String = ""
    
    // @Query var data: [Type]
    
    var body: some View {
        NavigationView {
            if searchTerm.isEmpty { // 검색어 없을 때
                VStack() {
                    /* 240522 Yu:D
                     지난 선곡 섹션 추가해야 함
                     if !data.isEmpty {
                        MusicItemRowView(itemRowTitle: "지난 선곡", tracks: data)
                     }
                     */
                    
                    if let tracks = model.personalRecommendationTracks {
                            MusicItemRowView(itemRowTitle: "맞춤 랜덤 선곡", tracks: tracks)
                    }
                    
                    Spacer()
                }
                .navigationTitle("오늘의 첫곡 🎧")
                
            } else { // 검색어 있을 때
                MusicSearchView(searchTerm: $searchTerm)
            }
        }
        .searchable(text: $searchTerm, prompt: "아티스트, 노래")
    }
}

#Preview {
    HomeView()
}
