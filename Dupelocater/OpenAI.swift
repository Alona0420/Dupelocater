//
//  OpenAI.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import Foundation
import Alamofire

class OpenAI {
    private let postURL = "https://api.openai.com/v1/chat/completions"
    func sendChat(chat: [Chat]) async throws-> OpenAIChatResponse {
        
        let aiMessage = chat.map({OpenAIChatBox(role: $0.role, content: $0.content)})
        let body = OpenAIChat(model: "gpt-4", messages: aiMessage)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Keys.openAIKey)"]
        
        do{
            let response = try await AF.request(postURL, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
        
            return response
        } catch{
            print("Error in OpenAI: \(error)")
            throw error
        }
    } //func
} //class

struct OpenAIChat: Encodable {
    let model: String
    let messages: [OpenAIChatBox]
}

struct OpenAIChatBox: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
    private enum CodingKeys: String, CodingKey {
            case choices
    }
}

struct OpenAIChatChoice : Decodable{
    let message: OpenAIChatBox
//    private enum CodingKeys: String, CodingKey {
//            case message
//    }
}
