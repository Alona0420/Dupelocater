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
    func sendChat(chat: [Chat]) async -> OpenAIChatResponse? {
        
        let aiMessage = chat.map({OpenAIChatBox(role: $0.role, content: $0.content)})
        let body = OpenAIChat(model: "gpt-3.5-turbo", messages: aiMessage)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Keys.openAIKey)"]
        return try? await AF.request(postURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
        
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
    case user
    case system
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice : Decodable{
    let message: OpenAIChatBox
}
