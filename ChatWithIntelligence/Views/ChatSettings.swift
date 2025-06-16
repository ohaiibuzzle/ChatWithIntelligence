//
//  ChatSettings.swift
//  ChatWithIntelligence
//
//  Created by Venti on 16/6/25.
//

import SwiftUI

struct ChatSettings: View {
    @ObservedObject var chat: Chat
    @Binding var state: Bool
    
    @State private var systemPrompt = Preferences.shared.systemPrompt
    @State private var temperature = Preferences.shared.temperature
    
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            Form {
                TextField("System Prompt", text: $systemPrompt)
                    .disabled(!chat.messages.isEmpty)
                HStack {
                    Slider(value: $temperature,
                           in: 0.1...2.0, step: 0.05) {
                        Text("Temperature")
                    }
                    
                    Text(String(format: "%.2f", temperature))
                }
            }
            
            Button("Done") {
                state.toggle()
            }
            .padding(.top)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
