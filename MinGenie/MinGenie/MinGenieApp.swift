//
//  MinGenieApp.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//

import SwiftData
import SwiftUI

@main
struct MinGenieApp: App {
    @StateObject private var shakeDetectionModel = ShakeDetectionModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: StoredTrackID.self)
        }
    }
}
