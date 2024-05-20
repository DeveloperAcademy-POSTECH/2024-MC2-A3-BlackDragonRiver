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
    @Published var tracks: MusicItemCollection<Track>?
    
    var playlist: Playlist?
    
    
    init() {
        self.requestMusicPersonalRecommendation()
    }
    
    private func requestMusicPersonalRecommendation() {
        Task {
            do {
                let request = MusicPersonalRecommendationsRequest()
                let response = try await request.response()
                await self.findPlaylist(response)
                try? await loadTracks()
                
            } catch {
                print("Personal recommendation request failed with error: \(error)")
            }
        }
    }
    
    /// Loads tracks asynchronously.
    private func loadTracks() async throws {
        guard let playlist = self.playlist else {
            print("🚫 Playlist Problem")
            return
        }
        
        let detailedAlbum = try await playlist.with([.tracks])
        await update(tracks: detailedAlbum.tracks)
    }
    
    private func findPlaylist(_ response: MusicPersonalRecommendationsResponse) async {
        self.personalRecommendations = response.recommendations
        for recommendation in self.personalRecommendations {
            if !recommendation.playlists.isEmpty {
                self.playlist = recommendation.playlists.first
                break
            }
        }
    }
    
    @MainActor
    private func update(tracks: MusicItemCollection<Track>?) {
        withAnimation {
            self.tracks = tracks
        }
    }
}
