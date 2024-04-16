//
//  ChatModel.swift
//  Dupelocater
//  Chat box model.
//  Created by Jayla Scott on 1/26/24.
//

import Foundation
extension ChatBox{
    class ViewModel: ObservableObject{
        @Published var isShowingProductCards = false
        
        func showProductCards() {
            isShowingProductCards = true
        }
        //@Published var chat: [Chat] = [] //for gpt3.5
        //for gpt 4
        @Published var chat: [Chat] = [Chat(id: UUID(), role: .system, content: "You are a personal shopping assistant tasked to find dupes for fashion and makeup products with listed prices and url links included. If users ask for sustainable options give them sustainable dupes. You know nothing else outside of fashion and makeup finds.", createAt: Date())]
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
                print("Received response:",response)
                
                guard let receivedAIMessage = response.choices.first?.message else {
                    print("No received messages") //error checking
                    completion(true)
                    return
                    //return false
                }
                
                let receivedMessage = Chat(id: UUID(), role: receivedAIMessage.role, content: receivedAIMessage.content, createAt: Date())
                chat.append(receivedMessage)
                
                // Pass the received message content to parseAPIResponse
                let productCards = parseAPIResponse(response: receivedAIMessage.content)
                print("Parsed product cards:", productCards) // Print the parsed product cards for debugging
                        
                
                completion(true)
                //return true
            } catch {
                print("Error Chat model: \(error)")
                completion(false)
                //return false
            }
        }
        
        func parseAPIResponse(response: String) -> [ProductCards] {
            var productCards: [ProductCards] = []
            // Print the response for debugging
            print("Response to parse:", response)
            
            let productEntries = response.components(separatedBy: "\n\n")
            print("Product entries", productEntries)
            
            for entry in productEntries {
                let components = entry.components(separatedBy: "\n   ")
                if components.count >= 3 {
                    let productName = components[0].replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let description = components[1]
                    let priceString = components[2].replacingOccurrences(of: "Price: $", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Replace the URL extraction logic with the actual URL from the response
                    let url = "https://example.com/sample_product_image.jpg" // Replace this with the actual URL from the response
                    
                    if let price = Double(priceString), let imageURL = URL(string: url) {
                        let productCard = ProductCards(
                            name: productName,
                            imageURL: imageURL,
                            cost: price
                            // Add other properties as needed
                        )
                        productCards.append(productCard)
                        print("Parsed product cards in parse:", productCards) // Print the parsed product cards for debugging
                    }
                }
            }
            
            return productCards
            
        } //parseAPIResp
        
    }
    
}//viewModel
    
    
//    func parseAPIResponse(response: String) -> [ProductCards] {
//            var productCards: [ProductCards] = []
//
//            let productEntries = response.components(separatedBy: "\n\n")
//
//            for entry in productEntries {
//                let components = entry.components(separatedBy: "\n   ")
//                if components.count >= 3 {
//                    let productName = components[0].replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
//                    let description = components[1]
//                    let priceString = components[2].replacingOccurrences(of: "Price: $", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
//                    if let price = Double(priceString), let urlRange = description.range(of: "\\(.*?\\)", options: .regularExpression) {
//                        let url = description[urlRange].replacingOccurrences(of: "[\\[\\]()]", with: "", options: .regularExpression, range: nil)
//
//                        let productCard = ProductCards(
//                            name: productName,
//                            imageURL: URL(string: url)!,
//                            cost: price
//                             // Assuming URL is in correct format
//                            // Add other properties as needed
//                        )
//                        productCards.append(productCard)
//                    }
//                }
//            }
//
//            return productCards
//        }
 
//extension






struct Chat: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
    
    static func systemMessage(content: String) -> Chat {
            return Chat(id: UUID(), role: .system, content: content, createAt: Date())
        }
}
