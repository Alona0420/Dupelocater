//
//  ChatModel.swift
//  Dupelocater
//  Chat box model
//  Created by Jayla Scott on 1/26/24.
//

import Foundation
extension ChatBox{
    class ViewModel: ObservableObject{
        @Published var chat: [Chat] = []
        @Published var currInput: String = ""
        
        private let openAI = OpenAI()
        
        func sendChat() {
            
            let newMsg = Chat(id: UUID(), role: .user, content: currInput, createAt: Date() )
            chat.append(newMsg)
            currInput = ""
            
            Task{
                let response = await openAI.sendChat(chat: chat)
                guard let recievedAIMessage = response?.choices.first?.message else {
                    print("No received messages") //error checking
                    return
                }
                let receivedMessage = Chat(id: UUID(), role: recievedAIMessage.role, content: recievedAIMessage.content, createAt: Date())
                await MainActor.run {
                    chat.append(receivedMessage)
                }
            }
        }
    }
    
} //extension

struct Chat: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
