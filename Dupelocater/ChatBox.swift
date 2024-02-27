//
//  ChatBox.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI

struct ChatBox: View {
    @ObservedObject var chatModel = ViewModel()
    @State private var isWaitingForResponse = false // Flag to track whether the response is being fetched
    var body: some View {
        ZStack{
            Color("primary")
            VStack{
                ScrollView{
                    ForEach(chatModel.chat.filter({$0.role != .system}), id: \.id){ chat in
                        chatView(chat: chat)
                    }
                }
                HStack{
                    TextField("Enter a message...", text: $chatModel.currInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button{
                        //chatModel.sendChat()
                        Task {
                                                await sendMessage()
                                            }
                    }label: {
                        Text("Send     ")
                    }
                    .padding(.trailing)
                } //Hstack
                .padding(.bottom)
            } //VStack
            //.edgesIgnoringSafeArea(.all)
            // Show loading indicator while waiting for response
                        if isWaitingForResponse {
                            //ProgressView("Waiting for response...")
                                //.padding()
                            HStack {
                                               Spacer()
                                               Text("Processing...")
                                                   .padding()
                                                   .background(Color.gray.opacity(0.2))
                                                   .cornerRadius(10)
                                               Spacer()
                                           }
                                           .padding(.bottom)
                        }
        }
        //.edgesIgnoringSafeArea(.all)
    } //View
    
    func sendMessage() async {
            isWaitingForResponse = true // Set flag to true to show loading indicator

        do {
                try await chatModel.sendChat { success in
                    if success {
                        // Handle success case
                        print("Message sent successfully")
                    } else {
                        // Handle failure case
                        print("Failed to send message")
                    }
                }
            } catch {
                print("Error sending message: \(error)")
            }

            isWaitingForResponse = false // Set flag to false when response is received
        }
    
    func chatView(chat: Chat) -> some View{
        HStack{
            if chat.role == .user { Spacer()}
            Text(chat.content)
                .padding()
                .background(chat.role == .user ? Color("primaryRed") : Color.gray.opacity(0.2))
            if chat.role == .assistant { Spacer()}
        }
    }
}

struct ChatBox_Previews: PreviewProvider {
    static var previews: some View {
        ChatBox()
    }
}
