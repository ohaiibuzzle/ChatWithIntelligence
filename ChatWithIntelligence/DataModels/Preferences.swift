//
//  Preferences.swift
//  ChatWithIntelligence
//
//  Created by Venti on 16/6/25.
//
import SwiftUI

struct Preferences {
    static let shared = Preferences()
    
    @AppStorage("systemPrompt") var systemPrompt: String = "You are a helpful assistant"
    @AppStorage("temperature") var temperature: Double = 0.8
}
