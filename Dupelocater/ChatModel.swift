//
//  ChatModel.swift
//  Dupelocater
//  Chat box model.
//  Created by Jayla Scott on 1/26/24.
//

import Foundation
extension ChatBox{
    class ViewModel: ObservableObject{
        @Published var isShowingProductCards = true

           func showProductCards() {
               isShowingProductCards = true
           }
        //@Published var chat: [Chat] = [] //for gpt3.5
        //for gpt 4
        @Published var chat: [Chat] = [Chat(id: UUID(), role: .system, content: "You are a personal shopping assistant tasked to find dupes for fashion and makeup products with listed prices and url links included. You know nothing else outside of fashion and makeup finds.", createAt: Date())]
        //[Chat(id: UUID(), role: .system, content: "Welcome to your Dupelicator", createAt: Date())]
        @Published var currInput: String = ""
        @Published var response: String? // Add a property to store the API response
        @Published var productCards: [ProductCard] = [] // Add a published property for productCards
        private let openAI = OpenAI()
        
        func sendChat(completion: @escaping (Bool) -> Void) async  {
            let newMsg = Chat(id: UUID(), role: .user, content: currInput, createAt: Date() )
            chat.append(newMsg)
            currInput = ""
            let systemMessage = Chat.systemMessage(content: "Processing...")
                    chat.append(systemMessage)
            do {
                    let response = try await openAI.sendChat(chat: chat)
                    //parseAndSendResponse(response: response)
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
    
    func parseAPIResponse(response: String) -> [ProductCard] {
            var productCards: [ProductCard] = []
            
            let productEntries = response.components(separatedBy: "\n\n")
            
            for entry in productEntries {
                let components = entry.components(separatedBy: "\n   ")
                if components.count >= 3 {
                    let productName = components[0].replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let description = components[1]
                    let priceString = components[2].replacingOccurrences(of: "Price: $", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    if let price = Double(priceString), let urlRange = description.range(of: "\\(.*?\\)", options: .regularExpression) {
                        let url = description[urlRange].replacingOccurrences(of: "[\\[\\]()]", with: "", options: .regularExpression, range: nil)
                        
                        let productCard = ProductCard(
                            productName: productName,
                            price: price,
                            uRL: URL(string: url)! // Assuming URL is in correct format
                            // Add other properties as needed
                        )
                        productCards.append(productCard)
                    }
                }
            }
            
            return productCards
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
