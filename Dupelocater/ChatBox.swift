//
//  ChatBox.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI
import UIKit

struct ProductCard {
    let productName: String
    let price: Double
    let uRL: URL
    // Add other properties as needed
}




struct ChatBox: View {
    @ObservedObject var chatModel = ViewModel()
    @State private var isWaitingForResponse = false // Flag to track whether the response is being fetched
    var body: some View {
        NavigationView {
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
                            .padding()
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
//                        Button( action: {
//                            ProductCardPage(productCards: chatModel.productCards); chatModel.isShowingProductCards
//                            
//                            }){
//                            Text("Products     ")
//                        }
                    } //Hstack
                    .padding(.bottom)
                    
//                    NavigationLink(
//                                            destination: ProductCardPage(productCards: chatModel.productCards),
//                                            isActive: $chatModel.isShowingProductCards,
//                                            label: { EmptyView() }
//                                        )
//                                        .hidden()
                    
                } //VStack
                //.edgesIgnoringSafeArea(.all)
                // Show loading indicator while waiting for response
                if isWaitingForResponse {
                    //ProgressView("Waiting for response...")
                    //.padding()
                    HStack {
                        Spacer()
                        Text("Dupeing...")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                    .padding(.bottom)
                }
            }
            .edgesIgnoringSafeArea(.all)
//            .onReceive(chatModel.$isShowingProductCards) { isShowing in
//                            if isShowing {
//                                NavigationLink(
//                                    destination: ProductCardPage(productCards: chatModel.productCards),
//                                    isActive: $chatModel.isShowingProductCards,
//                                    label: { EmptyView() }
//                                )
//                                //.hidden()
//                            }
//                        }

        }
        .navigationBarHidden(false) // Hide the navigation bar
        .navigationBarTitle(Text("Dupelocator"), displayMode: .inline)

        
        
    } //View
    
    func sendMessage() async {
            isWaitingForResponse = true // Set flag to true to show loading indicator

        do {
                try await chatModel.sendChat { success in
                    if success {
                        // Handle success case
                        print("Message sent successfully")
                        
//                        if let response = chatModel.response {
//                            let productCards = parseAPIResponse(response: response)
//                                            chatModel.productCards = productCards
//                                            chatModel.showProductCards() // Activate the flag to show product cards page
//                            print("Response recieved")
//                            //print(productCard.productName)
//                            }
                    }
//                    else {
//                        // Handle failure case
//                        print("Failed to send message")
//                    }
                }
            
            } catch {
                print("Error sending message: \(error)")
            }

            isWaitingForResponse = false // Set flag to false when response is received
    }
    
    func chatView(chat: Chat) -> some View{
        HStack{
            if chat.role == .user { Spacer() }
           
            AttributedText(chat.content)
                .padding()
                .background(chat.role == .user ? Color("chatBox") : Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
//                .overlay(alignment: .bottomLeading){
//                    Image(systemName: "arrowtriangle.down.fill")
//                        .font(.title)
//                        .rotationEffect(.degrees(300))
//                        .offset(x:30, y:10)
//                        .foregroundColor(Color("primaryRed"))
//                }
                .padding([.top], 45)
                .padding([.trailing], 6)
                .gesture(TapGesture().onEnded {
                    if chat.role == .assistant {
                        if let url = URL(string: chat.content), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                                })
                //.padding(.vertical)
            if chat.role == .assistant { Spacer()}
            if chat.role == .system{ Spacer()}
        }
    }
}

struct ChatBox_Previews: PreviewProvider {
    static var previews: some View {
        ChatBox()
    }
}

// Custom View to handle NSAttributedString
struct AttributedText: View {
    private var attributedString: NSAttributedString
    
    init(_ text: String) {
        //self.attributedString = NSAttributedString(string: text)
        let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.link, value: "https://example.com", range: NSRange(location: 0, length: text.count)) // Replace "https://example.com" with your actual URL
                self.attributedString = attributedText
    }
    
    var body: some View {
        Text(attributedString.string)
            .onTapGesture {
                let range = NSRange(location: 0, length: attributedString.length)
                attributedString.enumerateAttribute(.link, in: range, options: []) { value, range, _ in
                    if let url = value as? URL {
                        UIApplication.shared.open(url)
                    }
                }
            }
    }
}


//struct ProductCardView: View {
//    let productCard: ProductCard
//    
//    var body: some View {
//        VStack {
//            Text(productCard.productName)
//            Text("\(productCard.price)")
//            // Display image, URL, and other details as needed
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
//        .padding()
//    }
//}
