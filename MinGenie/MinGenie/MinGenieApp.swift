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
    @StateObject var musicPlayerModel = MusicPlayerModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(musicPlayerModel)
        }
    }
}
