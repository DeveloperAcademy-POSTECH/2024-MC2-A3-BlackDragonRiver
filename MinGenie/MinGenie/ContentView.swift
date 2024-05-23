//
//  ContentView.swift
//  MinGenie
//
//  Created by 김유빈 on 5/13/24.
//

import MusicKit
import SwiftUI


struct ContentView: View {
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    var body: some View {
        if hasSeenOnboarding {
            HomeView()
        } else {
            OnboardingTabView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}


#Preview {
    ContentView()
}
