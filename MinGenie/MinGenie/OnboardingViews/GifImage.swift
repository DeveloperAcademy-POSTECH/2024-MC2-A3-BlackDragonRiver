//
//  GifImage.swift
//  MinGenie
//
//  Created by 김하준 on 5/22/24.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        
        // Set the background color to black
        webview.isOpaque = false
        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            } catch {
                print("Failed to load GIF data: \(error.localizedDescription)")
            }
        } else {
            print("GIF not found: \(name).gif")
        }
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

extension GifImage {
    init(_ name: String) {
        self.name = name
    }
}
