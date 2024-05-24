import Combine
import MusicKit
import SwiftUI

/// ✏️ 재생기 기능을 하는 MusicPlayerModel 스크립트입니다 ✏️
///
/// (개념 정리) Combine 비동기처리
/// Publisher: 값이나 이벤트를 생성하고 방출하는 역할
/// Subscriber: Publisher로부터 방출된 값을 수신하여 처리하는 역할
/// Data Stream: Publisher에서 Subscriber까지 이어지는 데이터의 흐름
/// Combine = 이 데이터 스트림 과정에서 비동기 이벤트를 효율적으로 처리하는 것!

/// 대략적인 과정 : MusicPlayerModel의 play 함수 실행 ➡️ MusicKit의 MusicPlayer(본체)의 queue에 해당 곡 담은 후 재생

class MusicPlayerModel: ObservableObject {
    
    // MARK: - Properties
    @Published var isPlaying = false
    
    var playbackStateObserver: AnyCancellable?
    
    /// Return : Queue가 셋팅된 ApplicationMusicPlayer
    private var musicPlayer: ApplicationMusicPlayer {
        let musicPlayer = ApplicationMusicPlayer.shared
        if playbackStateObserver == nil {
            playbackStateObserver = musicPlayer.state.objectWillChange
                .sink { [weak self] in
                    self?.handlePlaybackStateDidChange()
                }
        }
        return musicPlayer
    }
    
    private var isPlaybackQueueInitialized = false
    private var playbackQueueInitializationItemID: MusicItemID?
    
    // MARK: - Methods
    
    func togglePlaybackStatus<MusicItemType: PlayableMusicItem>(for item: MusicItemType) {
        if !isPlaying {
            
            let isPlaybackQueueInitializedForSpecifiedItem = isPlaybackQueueInitialized && (playbackQueueInitializationItemID == item.id)
            
            if !isPlaybackQueueInitializedForSpecifiedItem {
                let musicPlayer = self.musicPlayer
                
                setQueue(for: [item])
                isPlaybackQueueInitialized = true
                playbackQueueInitializationItemID = item.id
                
                Task {
                    do {
                        try await musicPlayer.play()
                    } catch {
                        print("Failed to prepare music player to play \(item).")
                    }
                }
            }
            else {
                Task {
                    try? await musicPlayer.play()
                }
            }
        }
        else {
            musicPlayer.pause()
        }
    }

    func togglePlaybackStatus() {
        if !isPlaying {
            Task {
                try? await musicPlayer.play()
            }
        } else {
            musicPlayer.pause()
        }
    }
    
    /// 🐯
    /// 개별 곡 재생하고 그 뒤에 추천 플레이리스트 붙여주기
    /// - Parameter song: 사용자가 선택한 개별 곡
    func playRandomMusic() async {
        let model = NextMusicRecommendationModel()
        
        /// 추천 트랙 추가
        Task {
            let recommendedList = try await model.requestNextMusicList()
            if let recommendedList {
                play(recommendedList[0], in: recommendedList, with: nil)
            }
        }
    }
    
    /// 🐯
    func playMusicWithRecommendedList(_ song: Song) {
        let model = NextMusicRecommendationModel()
        let track = fromSongToTrackType(song)
        
        // 개별 곡 재생
        play(track, in: nil, with: nil)
        
        // 추천 트랙 추가
        Task {
            let recommendedList = try await model.requestNextMusicList()
            if let recommendedList {
                try await ApplicationMusicPlayer.shared.queue.insert(recommendedList, position: .tail)
            }
        }
    }
    
    /// 🐯
    /// 앨범 전체 재생하고 그 뒤에 추천 플레이리스트 붙여주기
    /// - Parameter tracks: 사용자가 선택한 전체 재생할 앨범에 담긴 트랙
    func playAlbumWithRecommendedList(_ tracks: MusicItemCollection<Track>) {
        let model = NextMusicRecommendationModel()
        
        // 앨범 재생
        play(tracks[0], in: tracks, with: nil)

        // 추천 트랙 추가
        Task {
            let recommendedList = try await model.requestNextMusicList()
            if let recommendedList {
                try await ApplicationMusicPlayer.shared.queue.insert(recommendedList, position: .tail)
            }
        }
    }
    
    /// ⭐️ 함께 활용할 함수 ⭐️
    /// 파라미터 1: 시작할 곡, 2: 트랙리스트 (곡 리스트), 3: 모르겠음
    func play(_ track: Track, in trackList: MusicItemCollection<Track>?, with parentCollectionID: MusicItemID?) {
        let musicPlayer = self.musicPlayer
        
        if let specifiedTrackList = trackList {
            /// 개별 재생
            setQueue(for: specifiedTrackList, startingAt: track)
        } else {
            setQueue(for: [track])
        }
        
        isPlaybackQueueInitialized = true
        playbackQueueInitializationItemID = parentCollectionID
        
        Task {
            do {
                try await musicPlayer.play()
            } catch {
                print("Failed to prepare music player to play \(track).")
            }
        }
    }
    
    /// (추가) song -> Track 컨버터
    func sendToMusicPlayer(_ song: Song) {
        let track = Track.song(song)
        play(track, in: nil, with: nil)
    }
    
    /// 🐰 Song 타입을 Track 타입으로 변경
    /// - Parameter song: Track 타입으로 변경할 Song
    /// - Returns: 전달받은 Song을 Track 타입으로 변환 후 반환
    private func fromSongToTrackType(_ song: Song) -> Track {
        Track.song(song)
    }
    
    /// (추가) 다음곡으로 넘기기!
    func skipToNextEntry() {
        Task {
            do {
                try await musicPlayer.skipToNextEntry()
            } catch {
                print("Failed to skip to the next entry: \(error)")
            }
        }
    }
    
    private func setQueue<S: Sequence, PlayableMusicItemType: PlayableMusicItem>(
        for playableItems: S,
        startingAt startPlayableItem: S.Element? = nil
    ) where S.Element == PlayableMusicItemType {
        ApplicationMusicPlayer.shared.queue = ApplicationMusicPlayer.Queue(for: playableItems, startingAt: startPlayableItem)
    }
    
    private func handlePlaybackStateDidChange() {
        isPlaying = (musicPlayer.state.playbackStatus == .playing)
    }
    
}
