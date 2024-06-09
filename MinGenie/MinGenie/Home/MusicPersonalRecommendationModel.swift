//
//  MusicPersonalRecommendationModel.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import MusicKit
import SwiftUI

//MARK: - MusicPersonalRecommendationModel
// Apple music에서 제공하는 개인 맞춤 리스트에서 플레이 리스트만을 관리해주는 모델
final class MusicPersonalRecommendationModel: ObservableObject {
    private var personalRecommendations: MusicItemCollection<MusicPersonalRecommendation> = []
    private var playlists: MusicItemCollection<Playlist> = []
    
    @Published var personalRecommendationTracks: MusicItemCollection<Track>?
    
    init() {
        Task {
            self.requestMusicPersonalRecommendation()
        }
    }
    
    /// apple music에서 맞춤 개인 선곡 리스트를 요청하는 메서드입니다.
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
    
    
    /// 맞춤 개인 선곡 리스트에서 playlist만 찾아주는 메서드입니다.
    private func findPlaylist(_ response: MusicPersonalRecommendationsResponse) async {
        self.personalRecommendations = response.recommendations
        for recommendation in personalRecommendations {  // 추천 목록에서 플레이리스트만을 선택합니다.
            if !recommendation.playlists.isEmpty {
                playlists += recommendation.playlists
            }
        }
        try? await loadRecommendationRandomTracks()
    }
    
    
    /// apple music에서 제공하는 개인 맞춤 플레이 리스트 중 랜덤으로 플리를 선택한 후, 트랙 배열로 전달합니다.
    private func loadRecommendationRandomTracks() async throws {
        guard let playlist = playlists.randomElement() else {
            print("🚫 Random Playlists Problem")
            return
        }
        
        let detailedPlaylist = try await playlist.with([.tracks])
        
        guard let tracks = detailedPlaylist.tracks else {
            print("🚫 Tracks Problem")
            return
        }
        await mainTracksUpdate(tracks)
    }

        
    @MainActor
    private func mainTracksUpdate(_ tracks: MusicItemCollection<Track>) {
            personalRecommendationTracks = tracks
    }
}
