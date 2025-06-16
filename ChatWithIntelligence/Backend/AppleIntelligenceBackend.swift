//
//  AppleIntelligenceBackend.swift
//  ChatWithIntelligence
//
//  Created by Venti on 13/6/25.
//

import FoundationModels

class AppleIntelligenceBackend {
    let session: LanguageModelSession
    var generationOptions = GenerationOptions()
    
    init() {
        session = LanguageModelSession()
        session.prewarm()
    }
    
    init(systemPrompt: String)
    {
        session = LanguageModelSession(instructions: systemPrompt)
        session.prewarm()
    }
    
    static func isIntelligenceAvailable() -> Bool {
        let model = SystemLanguageModel.default
        return model.isAvailable
    }
    
    static func whyIsIntelligence() -> SystemLanguageModel.Availability {
        let model = SystemLanguageModel.default
        
        return model.availability
    }
    
    func processRequest(prompt: String) -> LanguageModelSession.ResponseStream<String> {
        return session.streamResponse(to: prompt, options: generationOptions)
    }
}
