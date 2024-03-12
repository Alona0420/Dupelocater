//
//  ChatModel.swift
//  Dupelocater
//  Chat box model.
//  Created by Jayla Scott on 1/26/24.
//

import Foundation
extension ChatBox{
    class ViewModel: ObservableObject{
        //@Published var chat: [Chat] = [] //for gpt3.5
        //for gpt 4
        @Published var chat: [Chat] = [Chat(id: UUID(), role: .system, content: "You are a personal shopping assistant tasked to find dupes for fashion and makeup products. You know nothing else outside of fashion and makeup finds.", createAt: Date())]
        //[Chat(id: UUID(), role: .system, content: "Welcome to your Dupelicator", createAt: Date())]
        @Published var currInput: String = ""
        @Published var chatResults: [String] = [] // Publish chatResults directly
        @Published var showSwipingFeature = false
        @Published var areResultsAvailable = false
        
        private let openAI = OpenAI()
//        
        func sendChat() {
            let newMsg = Chat(id: UUID(), role: .user, content: currInput, createAt: Date() )
            chat.append(newMsg)
            currInput = ""
            
            
            Task{
                do{
                    let response = try await openAI.sendChat(chat: chat)
                    print(response)
//                    let responseData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
//                    print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
                    guard let recievedAIMessage = response.choices.first?.message else {
                        print("No received messages") //error checking
                        return
                    }
                    let receivedMessage = Chat(id: UUID(), role: recievedAIMessage.role, content: recievedAIMessage.content, createAt: Date())
                    await MainActor.run {
                        chat.append(receivedMessage)
                        chatResults = [recievedAIMessage.content] // Update chatResults
                        //chatResults = response.choices.map { $0.message.content } // Update chatResults with actual results content
                        print("Chat results received:", chatResults)
                            areResultsAvailable = true // Set to true when results are available
                        
                    }
                } catch{
                    print("Error Chat model: \(error)")}
                
            } //Task
            
            // Simulated sending chat and receiving results
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.chatResults = ["Result 1", "Result 2", "Result 3"] // Example results
                        print("Chat results updated:", self.chatResults)
                        self.showSwipingFeature = true // Activate navigation to SwipingFeature
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
