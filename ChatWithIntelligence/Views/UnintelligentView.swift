//
//  UnintelligentView.swift
//  ChatWithIntelligence
//
//  Created by Venti on 16/6/25.
//

import SwiftUI
import FoundationModels

struct UnintelligentView: View {
    var body: some View {
        VStack{
            Text("Apple Intelligence is not currently available on this system")
                .font(.headline)
            
            switch AppleIntelligenceBackend.whyIsIntelligence() {
            case .unavailable(.appleIntelligenceNotEnabled):
                Text("Enable it in Settings")
            case .unavailable(.deviceNotEligible):
                Text("This device does not support Apple Intelligence features")
            case .unavailable(.modelNotReady):
                Text("The model isn't ready. Try again in a few minutes")
            default:
                Text("An unknown error has occured.")
            }
        }
    }
}
