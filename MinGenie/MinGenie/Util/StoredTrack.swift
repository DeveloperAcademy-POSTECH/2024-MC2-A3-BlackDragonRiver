//
//  StoredTrack.swift
//  MinGenie
//
//  Created by zaehorang on 5/22/24.
//


import Foundation
import MusicKit
import SwiftData

@Model
final class StoredTrackID {
    @Attribute(.unique) var id: String
    var timestamp: Date
    
    init(_ song: Song) {
        self.id = song.id.rawValue
        self.timestamp = Date()
    }
    
}

extension StoredTrackID: Identifiable { }

extension StoredTrackID: Hashable {
    static func == (lhs: StoredTrackID, rhs: StoredTrackID) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
