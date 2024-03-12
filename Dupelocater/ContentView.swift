//
//  ContentView.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI
import CoreData

//struct ContentView: View {
//    @State private var isSendingMessage = false // State variable to track whether a message is being sent
//    private var people: [String] = ["Mario" , "Luigi", "Peach", "Toad", "Daisy"].reversed()
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                ForEach(people,id: \.self) { person in CardView (person: person)}
//            }
//        }
//                NavigationView {
//                    GeometryReader { geometry in
//                        Color("primary")
//                            .edgesIgnoringSafeArea(.all)
//                            .overlay(
//                                VStack {
//                                    Image("Logo")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//        
//                                    if isSendingMessage { // Show loading indicators while sending message
//                                        ProgressView("Sending...")
//                                            .progressViewStyle(CircularProgressViewStyle())
//                                            .padding()
//                                    } else {
//                                        NavigationLink(destination: ChatBox()) {
//                                            HStack {
//                                                Text("Lets DUPElocate!")
//                                                    .fontWeight(.bold)
//                                                    .foregroundColor(.white)
//                                            }
//                                            .padding()
//                                            .background(Color.red)
//                                            .cornerRadius(10)
//                                        }
//                                        .padding()
//                                    }
//                                }
//                            )
//                            .navigationBarHidden(true)
//                    }
//                }
//                .navigationViewStyle(StackNavigationViewStyle())
//            }
//    }
//    
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//}

//import SwiftUI
//
//struct ContentView: View {
//    @StateObject var viewModel = ChatBox.ViewModel()
//    @State private var showSwipingFeature = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Image("Logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding()
//
//                NavigationLink(destination: ChatBox(chatResults: $viewModel.chatResults)) {
//                    Text("Let's DUPElocate!")
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.red)
//                        .cornerRadius(10)
//                        .padding()
//                }
//                .padding(.horizontal)
//
//                if showSwipingFeature {
//                    NavigationLink(destination: SwipingFeature(results: $viewModel.chatResults)) {
//                        EmptyView()
//                    }
//                    .hidden()
//                    .onAppear {
//                        // Simulate the effect of immediately navigating to SwipingFeature
//                        DispatchQueue.main.async {
//                            showSwipingFeature = true
//                        }
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .onReceive(viewModel.$chatResults) { results in
//            if !results.isEmpty {
//                showSwipingFeature = true
//            }
//        }
//    }
//}
//
//
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//


import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ChatBox.ViewModel()
    @State private var showSwipingFeature = false // Add @State here

    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                NavigationLink(destination: ChatBox(chatResults: $viewModel.chatResults)) {
                    Text("Let's DUPElocate!")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $viewModel.showSwipingFeature) {
                    SwipingFeature(results: $viewModel.chatResults)
                }
        .onReceive(viewModel.$chatResults) { results in
            if !results.isEmpty {
                viewModel.showSwipingFeature = true
            }
            print("Received chat results:", results)
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
               .onReceive(viewModel.$chatResults) { results in
                   if !results.isEmpty {
                       viewModel.showSwipingFeature = true
                   }
               }
               
               .fullScreenCover(isPresented: $viewModel.showSwipingFeature) {
                   SwipingFeature(results: $viewModel.chatResults)
               }
        
        

        .onReceive(viewModel.$chatResults) { results in
            if !results.isEmpty {
                viewModel.showSwipingFeature = true
            }
        }
//        .navigationViewStyle(StackNavigationViewStyle())
//                .onReceive(viewModel.$chatResults) { results in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
//                        viewModel.showSwipingFeature = true
//                        print("Results received in ContentView:", results)
//                    }
//                }
//                .sheet(isPresented: $showSwipingFeature) {
//                            if !viewModel.chatResults.isEmpty {
//                                SwipingFeature(results: $viewModel.chatResults)
//                            } else {
//                                Text("Loading...")
//                            }
//                        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


