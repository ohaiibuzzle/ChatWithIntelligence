//
//  ChatList.swift
//  ChatWithIntelligence
//
//  Created by Venti on 6/2/25.
//

import Foundation
internal import Combine

class ChatList: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var needsUpdate = false
    
    static let shared = ChatList()

    private let saveFile = "chats.json"

    @discardableResult
    public func newChat() -> Chat {
        let newChat = Chat()
        // Put it at the front of the list
        chats.insert(newChat, at: 0)
        return newChat
    }

    public func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(chats) {
            try? data.write(to: URL(fileURLWithPath: saveFile))
        }
    }

    public func load() {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: saveFile)) {
            let decoder = JSONDecoder()
            if let loadedChats = try? decoder.decode([Chat].self, from: data) {
                self.chats = loadedChats
            }
        }
    }

    init() {
        load()
        if chats.isEmpty {
            newChat()
        }
    }

    public func delete(chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats.remove(at: index)
        }
    }
}
