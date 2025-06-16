//
//  ContentView.swift
//  ChatWithIntelligence
//
//  Created by Venti on 13/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if AppleIntelligenceBackend.isIntelligenceAvailable() {
            MainAppView()
        } else {
            UnintelligentView()
        }
    }
}

#Preview {
    ContentView()
}
