//
//  NextMusicRecommendationModel.swift
//  MinGenie
//
//  Created by zaehorang on 5/23/24.
//

import MusicKit

struct NextMusicRecommendationModel {
 
    func requestNextMusicList() async throws ->  MusicItemCollection<Track>? {
        let request = MusicPersonalRecommendationsRequest()
        let response = try await request.response()
        
        let playlist = try await findPlaylist(response)
        
        let tracks = try await loadRandomTracks(playlist)
        return tracks
        
    }
    
    private func findPlaylist(_ response: MusicPersonalRecommendationsResponse) async throws -> MusicItemCollection<Playlist> {
        
        var playlists: MusicItemCollection<Playlist> = []
        
        for recommendation in response.recommendations {
            if !recommendation.playlists.isEmpty {
                playlists += recommendation.playlists
            }
        }
        return playlists
    }
    
    private func loadRandomTracks(_ playlists: MusicItemCollection<Playlist>) async throws -> MusicItemCollection<Track>? {
        guard let playlist = playlists.randomElement() else {
            print("🚫 Random Playlists Problem")
            
            return nil
        }
        
        let detailedPlaylist = try await playlist.with([.tracks])
        
        guard let tracks = detailedPlaylist.tracks else {
            print("🚫 Tracks Problem")
            
            return nil
        }
        return tracks
    }
}
