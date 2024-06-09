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
    
    //MARK: init 메서드
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


//MARK: - TrackIDConverter
// Int 타입으로 저장된 음악 id값을 통해 해당 음악을 Track 타입으로 변환하여 전달하는 모델
class TrackIDConverter: ObservableObject {
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
