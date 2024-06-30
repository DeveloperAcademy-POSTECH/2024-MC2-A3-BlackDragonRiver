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
    // 개인 맞춤 음악 데이터를 위한 모델
    @StateObject private var musicPersonalRecommendationModel = MusicPersonalRecommendationModel()
    // 지난 선곡 데이터를 위한 모델
    @StateObject private var selectedMusicDataModel = TrackIDConverter()
    
    @State private var searchTerm: String = ""
    
    // 애플 뮤직 구독 상태 관리
    @State private var musicSubscription: MusicSubscription?
    @State private var isShowingSubscriptionOffer = false
    
    @Query(sort: \StoredTrackID.timestamp, order: .reverse) private var storedTrackIDs: [StoredTrackID]
    
    var body: some View {
        NavigationView {
            // 검색어 없을 때
            if searchTerm.isEmpty {
                Color.BG.main.ignoresSafeArea()
                    .overlay {
                        VStack(spacing: 0) {
                            if let tracks = selectedMusicDataModel.storedTracks {
                                MusicItemRowView(itemRowTitle: "지난 선곡", tracks: tracks)
                                    .padding(.bottom, 30)
                            }
                            
                            if let tracks = musicPersonalRecommendationModel.personalRecommendationTracks {
                                MusicItemRowView(itemRowTitle: "맞춤 랜덤 선곡", tracks: tracks)
                            }
                            
                            Spacer()
                        }
                        .navigationTitle("오늘의 첫곡 🎧")
                    }
            } else {
                // 검색어 있을 때
                MusicSearchView(searchTerm: $searchTerm)
            }
        }
        .tint(Color.accentColor)
        .searchable(text: $searchTerm, prompt: "아티스트, 노래")
        .onChange(of: storedTrackIDs) {
            selectedMusicDataModel.loadTracksByID(storedTrackIDs)
        }
        .onAppear {
            selectedMusicDataModel.loadTracksByID(storedTrackIDs)
        }
        .task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                musicSubscription = subscription
                isShowingSubscriptionOffer = !(musicSubscription?.canPlayCatalogContent ?? false)
            }
        }
        .musicSubscriptionOffer(isPresented: $isShowingSubscriptionOffer)
    }
}

#Preview {
    HomeView()
}
