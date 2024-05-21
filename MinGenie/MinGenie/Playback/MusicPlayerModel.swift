import Combine

/// (개념 정리) Combine 비동기처리
/// Publisher: 값이나 이벤트를 생성하고 방출하는 역할
/// Subscriber: Publisher로부터 방출된 값을 수신하여 처리하는 역할
/// Data Stream: Publisher에서 Subscriber까지 이어지는 데이터의 흐름
/// Combine = 이 데이터 스트림 과정에서 비동기 이벤트를 효율적으로 처리하는 것!

import MusicKit
import SwiftUI

/// ✏️ 재생기 기능을 하는 MusicPlayerModel 스크립트입니다 ✏️
///  애플 예제에서 따온 건데, custom한 부분들 표시해두겠습니다!

/// 대략적인 과정 : MusicPlayerModel의 play 함수 실행 ➡️ MusicKit의 MusicPlayer(본체)의 queue에 해당 곡 담은 후 재생

class MusicPlayerModel: ObservableObject {

    // MARK: - Initialization
    /// 싱글톤 인스턴스
    static let shared = MusicPlayerModel()
    
    init() {}
    
    // MARK: - Properties
    
    /// property 1 - 현재 재생되고 있는지를 체크하는 bool
    @Published var isPlaying = false
    
    /// property 2 - 재생곡이 MusicPlayer의 Queue에 담겨있는지, Combine 관련 변수
    /// AnyCancellable: Cancellable이라는 프로토콜의 구현체로 cancel()이라는 메서드를 호출하면 Publisher로부터 더이상 데이터 스트림을 받지 않는다. Memory Leak 방지.
    var playbackStateObserver: AnyCancellable?
    
    /// property 3 - 재생기가 queue를 체크해, 재생 준비를 시키는 과정이 담겨있음
    private var musicPlayer: ApplicationMusicPlayer {
        let musicPlayer = ApplicationMusicPlayer.shared
        
        /// 아무것도 subscribe하고 있지 않다면, 즉 재생할 곡이 담기지 않았다면 곡 관련 이벤트 publisher를 구독할 것!
        if playbackStateObserver == nil {
        
            /// objectWillChange는 곡이 변경되기 전에 이벤트를 발생시켜주는 publisher
            /// 1. sink() 를 통해 objectWillChange라는 publisher를 subscribe 시작
            /// 2. 이때 subscribe 취소할 수 있는 AnyCancellable 객체가 리턴되고 playbackStateObserver에 담김
            
            playbackStateObserver = musicPlayer.state.objectWillChange
                .sink { [weak self] in
                    /// publisher가 곡 바뀜 이벤트를 발생시키면, 이 스크립트 MusicPlayerModel Class 단에서도 재생 상태 체크 bool을 toggle시켜줌!
                    self?.handlePlaybackStateDidChange()
                }
        }
        ///  재생할 곡이 준비가 된 musicPlayer를 반환!
        return musicPlayer
    }
    
    /// property 4 - Queue에 담긴 첫번째 곡이 초기화되었는지(제대로 담겼는지) 체크하는 Bool
    private var isPlaybackQueueInitialized = false
    
    /// property 5 - Queue에 담긴 첫번째 곡의 ID값 String
    private var playbackQueueInitializationItemID: MusicItemID?
    
    // MARK: - Methods
    
    /// method 1-1 play / pause 토글시켜주는 함수 - playbutton에서 사용할 것!
    /// 재생할 음악을 Queue에 담아 준비시키는 과정이 담겨있음
    func togglePlaybackStatus<MusicItemType: PlayableMusicItem>(for item: MusicItemType) {
        /// 1. pause상태라면
        if !isPlaying {
            
            let isPlaybackQueueInitializedForSpecifiedItem = isPlaybackQueueInitialized && (playbackQueueInitializationItemID == item.id)
            
            /// 1-1. pause고 재생할 곡이 준비되지 않았다면
            if !isPlaybackQueueInitializedForSpecifiedItem {
                let musicPlayer = self.musicPlayer
                
                /// Queue에 담고, Queue에 담긴 첫번째 곡 관련 변수들 값 변경!
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
            /// 1-2. pause고 재생할 곡이 준비가 되었다면 Play
            else {
                Task {
                    try? await musicPlayer.play()
                }
            }
        } 
        /// 2. play 상태라면
        else {
            musicPlayer.pause()
        }
    }
    
    /// method 1-2 1-1함수 오버로딩
    func togglePlaybackStatus() {
        if !isPlaying {
            /// 곡 재생 데이터 가져오는 동안 비동기
            Task {
                try? await musicPlayer.play()
            }
        } else {
            musicPlayer.pause()
        }
    }
    /// method 2 : play
    /// parameter1:  track 시작할 곡
    /// parameter2: tracklist 트랙 리스트
    /// parameter3: ???
    
    /// 1만 넣으면 개별곡 재생되고 끝남!
    /// 1,2 넣으면 2 상의 1의 곡 index부터 시작해서 연속재생
    
    
    
    func play(_ track: Track, in trackList: MusicItemCollection<Track>?, with parentCollectionID: MusicItemID?) {
        let musicPlayer = self.musicPlayer
        
        if var specifiedTrackList = trackList {
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
    
    /// method 3 - PlayerableMusicItem을 MusicKit의 MusicPlayer의 Queue에 곡을 담아주는 함수
    /// (개념) sequence : 순차적인 요소의 컬렉션을 나타내는 프로토콜로, 배열 등이 이 프로토콜 채택하고 있음.
    private func setQueue<S: Sequence, PlayableMusicItemType: PlayableMusicItem>(
        for playableItems: S,
        startingAt startPlayableItem: S.Element? = nil
    ) where S.Element == PlayableMusicItemType {
        ApplicationMusicPlayer.shared.queue = ApplicationMusicPlayer.Queue(for: playableItems, startingAt: startPlayableItem)
    }
    
    /// method 4 -
    /// MusicKit단의 MusicPlayer - playbackStatus를 체크해서, 이 스크립트 단의 재생 체크 bool인 isPlaying값에 동기화!
    private func handlePlaybackStateDidChange() {
        isPlaying = (musicPlayer.state.playbackStatus == .playing)
    }
    
    /// 👉🏻 method 5 (custom)
    /// method 3 play의 파라미터 Track은 song, musicVideo 모두를 포괄하는 enum타입이라 case를 song으로 지정해서 넘겨줘야할 필요가 있음.
    func sendToMusicPlayer(_ song: Song, in trackList: MusicItemCollection<Track>?) {
        let track = Track.song(song)
        play(track, in: trackList, with: nil)
    }
    
}
