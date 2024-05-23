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
    @ObservedObject private var model = MusicPersonalRecommendationModel()
    @State private var searchTerm: String = ""
    
    @Query(sort: \StoredTrackID.timestamp, order: .reverse) var storedTrackIDs: [StoredTrackID]
    @State private var storedTracks: MusicItemCollection<Track>?
    
    var body: some View {
        NavigationView {
            if searchTerm.isEmpty { // 검색어 없을 때
                VStack() {

                    if let tracks = storedTracks {
                            MusicItemRowView(itemRowTitle: "지난 선곡", tracks: tracks)
                     }
                    
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
        .onChange(of: storedTrackIDs) {
            loadTracksByID()
        }
        .onAppear {
            loadTracksByID()
        }
    }
    
    private func loadTracksByID() {
        Task {
            if !storedTrackIDs.isEmpty {
                do {
                    let ids = storedTrackIDs.map { MusicItemID($0.id) }
                    
                    let request =  MusicCatalogResourceRequest<Song>(matching: \.id ,memberOf: ids)
                    let result = try await request.response()
                    
                    var tracks: MusicItemCollection<Track> = []
                    result.items.forEach { tracks += [Track.song($0)] }
                    storedTracks = tracks
                } catch {
                    print("Music ID request failed with error: \(error)")
                }
            } else { return }
        }
    }
}

#Preview {
    HomeView()
}
