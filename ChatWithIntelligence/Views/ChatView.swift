//
//  ChatView.swift
//  ChatWithIntelligence
//
//  Created by Venti on 13/6/25.
//

import SwiftUI
import FoundationModels
import MarkdownUI

struct MessageView: View {
    @StateObject var message: Message
    
    var body: some View {
        HStack {
            if message.role == MessageRole.user {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Text("You:")
                            .bold()
                    }
                    HStack {
                        Spacer()
                        Markdown(message.content)
                            .textSelection(.enabled)
                    }
                }
                .padding()
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Assistant:")
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Markdown(message.content)
                            .textSelection(.enabled)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
    }
}

struct CompactMessageView: View {
    @StateObject var message: Message
    
    var body: some View {
        HStack {
            if message.role == MessageRole.user {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Text("You:")
                            .bold()
                    }
                    HStack {
                        Spacer()
                        Markdown(message.content)
                            .textSelection(.enabled)
                    }
                }
                .padding()
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Assistant:")
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Markdown(message.content)
                            .textSelection(.enabled)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
    }
}

struct ChatView: View {
    @StateObject var chat: Chat
    @State private var message = ""
    @State private var isLoading = false
    
    @Binding var titleChanged: Bool
    @State var heightReduced = false
    @State private var settingsShown = false
    
    var body: some View {
        VStack {
            if chat.messages.isEmpty{
                Spacer()
                Section {
                    Text("Send a message to start")
                }
            } else {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(chat.messages, id: \.id) { message in
                                if heightReduced {
                                    CompactMessageView(message: message)
                                        .padding(.horizontal)
                                        .id(message.id)
                                    Divider()
                                } else {
                                    MessageView(message: message)
                                        .padding(.horizontal)
                                        .id(message.id)
                                    Divider()
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button {
                                    withAnimation {
                                        scrollView.scrollTo(chat.messages.first?.id)
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.circle.fill")
                                }
                                .buttonStyle(.borderless)
                                .padding([.horizontal, .bottom], 25)
                            }
                            .id("bottom")
                        }
                    }
                    .onChange(of: chat.messages) {
                        withAnimation {
                            scrollView.scrollTo("bottom")
                        }
                    }
                    .onChange(of: isLoading) {
                        withAnimation {
                            scrollView.scrollTo("bottom")
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                    )
                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                Section {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(LinearProgressViewStyle())
                    } else {
                        HStack {
                            TextField("Enter your message" ,text: $message)
                                .onSubmit {
                                    Task.detached {
                                        await sendMessage()
                                    }
                                }
                            Button {
                                Task.detached {
                                    await sendMessage()
                                }
                            } label: {
                                Image(systemName: "paperplane.fill")
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(message.isEmpty)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .background(Color.gray.opacity(0.1))
        .toolbar {
            Button{
                settingsShown.toggle()
            } label: {
                Image(systemName: "gear")
            }
        }
        .sheet(isPresented: $settingsShown) {
            ChatSettings(chat: chat, state: $settingsShown)
        }
    }
    
    func sendMessage() async {
        if message.isEmpty {
            return
        }
        
        if chat.messages.isEmpty {
            chat.title = message
            titleChanged.toggle()
        }
        
        let newMessage = Message(role: MessageRole.user, content: message)
        let request = chat.sendMessage(prompt: message)
        
        withAnimation{
            message = ""
            chat.messages.append(newMessage)
            chat.messages.append(Message(role: MessageRole.assistant, content: "Thinking... "))
        }
        
        Task(priority: .userInitiated) {
            Task { @MainActor in
                withAnimation {
                    isLoading.toggle()
                }
            }
            
            let newMessage = Message(role: .assistant, content: "")
            chat.messages.removeLast()
            chat.messages.append(newMessage)
            
            do {
                for try await stream in request
                {
                    Task { @MainActor in
                        newMessage.content = stream
                    }
                }
            } catch {
                print("Error!")
            }
            
            Task { @MainActor in
                withAnimation {
                    isLoading.toggle()
                }
            }
            ChatList.shared.save()
        }
    }
}
