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
        
        private let openAI = OpenAI()
        
        func sendChat(completion: @escaping (Bool) -> Void) async  {
            let newMsg = Chat(id: UUID(), role: .user, content: currInput, createAt: Date() )
            chat.append(newMsg)
            currInput = ""
            let systemMessage = Chat.systemMessage(content: "Processing...")
                    chat.append(systemMessage)
            do {
                    let response = try await openAI.sendChat(chat: chat)
                    print(response)

                    guard let receivedAIMessage = response.choices.first?.message else {
                        print("No received messages") //error checking
                        completion(true)
                        return
                        //return false
                    }

                    let receivedMessage = Chat(id: UUID(), role: receivedAIMessage.role, content: receivedAIMessage.content, createAt: Date())
                    chat.append(receivedMessage)
                completion(true)
                    //return true
                } catch {
                    print("Error Chat model: \(error)")
                    completion(false)
                    //return false
                }
            
            
//            Task{
//                do{
//                    let response = try await openAI.sendChat(chat: chat)
//                    print(response)
////                    let responseData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
////                    print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
//                    guard let recievedAIMessage = response.choices.first?.message else {
//                        print("No received messages") //error checking
//                        return
//                    }
//                    let receivedMessage = Chat(id: UUID(), role: recievedAIMessage.role, content: recievedAIMessage.content, createAt: Date())
//                    await MainActor.run {
//                        chat.append(receivedMessage)
//                    }
//                } catch{
//                    print("Error Chat model: \(error)")}
//
//            } //Task
        } //func
    }
    
} //extension

struct Chat: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
    
    static func systemMessage(content: String) -> Chat {
            return Chat(id: UUID(), role: .system, content: content, createAt: Date())
        }
}
