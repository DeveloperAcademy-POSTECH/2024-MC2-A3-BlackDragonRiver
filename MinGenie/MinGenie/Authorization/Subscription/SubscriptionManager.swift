//
//  SubscriptionManager.swift
//  MinGenie
//
//  Created by 김유빈 on 6/11/24.
//

import MusicKit
import SwiftUI

class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @State var musicSubscription: MusicSubscription?
    @Published var canPlayCatalogContent: Bool = false
    
    private init() {
        fetchSubscriptionStatus()
    }
    
    func fetchSubscriptionStatus() {
        Task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                
                musicSubscription = subscription
                
                DispatchQueue.main.async {
                    self.canPlayCatalogContent = self.musicSubscription?.canPlayCatalogContent ?? false
                }
            }
        }
    }
}
