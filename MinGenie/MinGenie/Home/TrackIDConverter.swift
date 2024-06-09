//
//  TrackIDConverter.swift
//  MinGenie
//
//  Created by zaehorang on 6/9/24.
//

import MusicKit
import SwiftUI

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
