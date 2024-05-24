//
//  SwiftUIView.swift
//  MinGenie
//
//  Created by dora on 5/23/24.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Circle()
            .fill(Color("Sub"))
        Circle()
            .fill(Color("shape/Blue"))
        Circle()
            .fill(Color("text/BLue"))
        Circle()
            .fill(Color("text/White80"))
        Circle()
            .fill(Color("bg/Main"))
        
    }
}

#Preview {
    SwiftUIView()
}
