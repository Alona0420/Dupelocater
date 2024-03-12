//
//  ChatBox.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

//import SwiftUI

//struct ChatBox: View {
//    @ObservedObject var chatModel = ViewModel()
//    var body: some View {
//        VStack{
//            ScrollView{
//                ForEach(chatModel.chat.filter({$0.role != .system}), id: \.id){ chat in
//                    chatView(chat: chat)
//                }
//            }
//            HStack{
//                TextField("Enter a message...", text: $chatModel.currInput)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                Button{
//                    chatModel.sendChat()
//                }label: {
//                    Text("Send     ")
//                }
//                .padding(.trailing)
//            } //Hstack
//            .padding(.bottom)
//        } //VStack
//    } //View
//    
//    func chatView(chat: Chat) -> some View{
//        HStack{
//            if chat.role == .user { Spacer()}
//            Text(chat.content)
//                .padding()
//                .background(chat.role == .user ? Color("chatBox") : Color.gray.opacity(0.2))
//            if chat.role == .assistant { Spacer()}
//        }
//    }
//}
//
//struct ChatBox_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatBox()
//    }
//}

import SwiftUI

struct ChatBox: View {
    @ObservedObject var chatModel = ViewModel()
    @Binding var chatResults: [String] // Binding to chatResults
     
    init(chatResults: Binding<[String]>) {
        _chatResults = chatResults
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatModel.chat.filter({ $0.role != .system }), id: \.id) { chat in
                    chatView(chat: chat)
                }
            }
            HStack {
                TextField("Enter a message...", text: $chatModel.currInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    chatModel.sendChat()
                }) {
                    Text("Send")
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }//VStack
        .background(
                   NavigationLink(
                       destination: SwipingFeature(results: $chatResults),
                       isActive: $chatModel.showSwipingFeature,
                       label: { EmptyView() }
                   )
                   .opacity(0) // Hide the NavigationLink
               )
    }
    
    func chatView(chat: Chat) -> some View {
        HStack {
            if chat.role == .user { Spacer() }
            Text(chat.content)
                .padding()
                .background(chat.role == .user ? Color("chatBox") : Color.gray.opacity(0.2))
            if chat.role == .assistant { Spacer() }
        }
    }
}

struct ChatBox_Previews: PreviewProvider {
    static var previews: some View {
        ChatBox(chatResults: .constant([]))
    }
}
