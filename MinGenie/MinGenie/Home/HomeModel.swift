//
//  HomeModel.swift
//  MinGenie
//
//  Created by zaehorang on 5/19/24.
//

import MusicKit
import SwiftUI

/// MusicPersonalRecommendationModel
/// SelectedMusicDataModel

//MARK: - MusicPersonalRecommendationModel
class MusicPersonalRecommendationModel: ObservableObject {
    private var personalRecommendations: MusicItemCollection<MusicPersonalRecommendation> = []
    private var playlists: MusicItemCollection<Playlist> = []
    
    @Published var personalRecommendationTracks: MusicItemCollection<Track>?
    
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

    /// 애플에서 제공하는 개인 맞춤 플레이 리스트 중 랜덤으로 트랙 배열을 전달한다.
    /// - Returns: 개인 맞춤 랜덤 트랙 배열
    func loadRandomTracks() async throws -> MusicItemCollection<Track>? {
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
    
    @MainActor
    private func mainTracksUpdate(_ tracks: MusicItemCollection<Track>) {
            personalRecommendationTracks = tracks
    }
}


//MARK: - FirstPickedMusicDataModel
// 로컬에 id로 저장되어 있는 지난 선곡 음악 데이터를 Track 타입으로 변환해주는 모델
class FirstPickedMusicDataModel: ObservableObject {
    @Published var storedTracks: MusicItemCollection<Track>?
    
    /// 로컬에 id로 저장되어 있은 음악 데이터를 Track 타입의 데이터 배열로 전환하는 메서드
    /// - Parameter storedTrackIDs:이전에 선택된 음악 id 데이터 배열
    func loadTracksByID(_ storedTrackIDs: [StoredTrackID]) {
        Task {
            if !storedTrackIDs.isEmpty {
                do {
                    let ids = storedTrackIDs.map { MusicItemID($0.id) }
                    
                    let request =  MusicCatalogResourceRequest<Song>(matching: \.id ,memberOf: ids)
                    let result = try await request.response()
                    
                    var tracks: MusicItemCollection<Track> = []
                    result.items.forEach { tracks += [Track.song($0)] }
                    
                    await storedTracksUpdate(tracks)
                } catch {
                    print("Music ID request failed with error: \(error)")
                }
            }
        }
    }
    
    @MainActor
    private func storedTracksUpdate(_ tracks: MusicItemCollection<Track>) {
            storedTracks = tracks
    }
    
}
