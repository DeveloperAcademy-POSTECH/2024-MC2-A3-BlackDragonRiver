//
//  HomeView.swift
//  MinGenie
//
//  Created by 김하준 on 5/22/24.
//

import MusicKit
import SwiftData
import SwiftUI

struct HomeView: View {
    @StateObject private var musicPersonalRecommendationModel = MusicPersonalRecommendationModel()
    @StateObject private var selectedMusicDataModel = FirstPickedMusicDataModel()
    
    @State private var searchTerm: String = ""
    
    @Query(sort: \StoredTrackID.timestamp, order: .reverse) private var storedTrackIDs: [StoredTrackID]
    
    var body: some View {
        NavigationView {
            if searchTerm.isEmpty { // 검색어 없을 때
                    VStack {
                        
                        if let tracks = selectedMusicDataModel.storedTracks {
                            MusicItemRowView(itemRowTitle: "지난 선곡", tracks: tracks)
                        }
                        
                        if let tracks = musicPersonalRecommendationModel.personalRecommendationTracks {
                            MusicItemRowView(itemRowTitle: "맞춤 랜덤 선곡", tracks: tracks)
                        }
                        
                        Spacer()
                        
                        MiniPlayerView()
                    }
                    .navigationTitle("오늘의 첫곡 🎧")
                    .ignoresSafeArea(.keyboard)
                
            } else { // 검색어 있을 때
                MusicSearchView(searchTerm: $searchTerm)
            }
        }
        .searchable(text: $searchTerm, prompt: "아티스트, 노래")
        .onChange(of: storedTrackIDs) {
            selectedMusicDataModel.loadTracksByID(storedTrackIDs)
        }
        .onAppear {
            selectedMusicDataModel.loadTracksByID(storedTrackIDs)
        }
    }
    
}

#Preview {
    HomeView()
}
