//
//  MusicPersonalRecommendationModel.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import MusicKit
import SwiftUI

class MusicPersonalRecommendationModel: ObservableObject {
    private var personalRecommendations: MusicItemCollection<MusicPersonalRecommendation> = []
    
    @Published var mainTracks: MusicItemCollection<Track>?
    @Published var randomTracks: MusicItemCollection<Track>?
    
    private var playlists: MusicItemCollection<Playlist> = []
    
    init() {
        Task {
            self.requestMusicPersonalRecommendation()
        }
    }
    
    private func requestMusicPersonalRecommendation() {
        Task {
            do {
                let request = MusicPersonalRecommendationsRequest()
                let response = try await request.response()
                
                await self.findPlaylist(response)
            } catch {
                print("Personal recommendation request failed with error: \(error)")
            }
        }
    }
    
    private func findPlaylist(_ response: MusicPersonalRecommendationsResponse) async {
        self.personalRecommendations = response.recommendations
        for recommendation in personalRecommendations {
            if !recommendation.playlists.isEmpty {
                playlists += recommendation.playlists
                
                if !playlists.isEmpty {  // 플리를 한 개라도 찾으면
                    try? await loadMainTracks()
                }
            }
        }
        print("❗️: \(playlists)")
    }
    
    /// Loads tracks asynchronously.
    private func loadMainTracks() async throws {
        let detailedPlaylist = try await playlists[0].with([.tracks])
        
        guard let tracks = detailedPlaylist.tracks else {
            print("🚫 Tracks Problem")
            return
        }
        
        await mainTracksUpdate(tracks)
    }
    

    
    func loadRandomTracks() async throws {
        guard let playlist = playlists.randomElement() else {
            print("🚫 Random Playlists Problem")
            return
        }
                
        let detailedPlaylist = try await playlist.with([.tracks])
        
        guard let tracks = detailedPlaylist.tracks else {
            print("🚫 Tracks Problem")
            return
        }
        
        await randomTracksUpdate(tracks)
    }
    
    @MainActor
    private func mainTracksUpdate(_ tracks: MusicItemCollection<Track>) {
            mainTracks = tracks
    }
    
    @MainActor
    private func randomTracksUpdate(_ tracks: MusicItemCollection<Track>) {
        randomTracks = tracks
    }
}
