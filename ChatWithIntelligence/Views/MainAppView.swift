//
//  NavigationView.swift
//  ChatWithIntelligence
//
//  Created by Venti on 16/6/25.
//

import SwiftUI

struct MainAppView: View {
    @State private var selection: UUID?
    @StateObject var chatList = ChatList.shared
    
    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading) {
                Text("Chats")
                    .font(.title)
                    .bold()
                    .padding()
                List(selection: $selection) {
                    ForEach(chatList.chats) { chat in
                        NavigationLink(value: chat.id) {
                            Text(chat.title)
                        }
                    }
                    .id(chatList.needsUpdate)
                }
            }
        } detail: {
            ZStack {
                if let selection {
                    let chat = chatList.chats.first(where: { $0.id == selection })!
                    ChatView(chat: chat, titleChanged: $chatList.needsUpdate)
                        .navigationTitle(chat.title)
                        .id(selection)
                }
                else {
                    Text("Select a chat")
                        .id(UUID())
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        if let selection {
                            chatList.chats.removeAll(where: { $0.id == selection })
                        }
                        selection = chatList.chats.first?.id ?? nil
                    } label: {
                        Image(systemName: "trash")
                    }
                    Button {
                        chatList.newChat()
                        selection = chatList.chats.first?.id
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationTitle("Chats")
        .onAppear() {
            selection = chatList.chats.first?.id
        }
    }
}
