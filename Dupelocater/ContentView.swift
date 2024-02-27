//
//  ContentView.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
//        ZStack{
//            Color.red
        NavigationView {
                    GeometryReader { geometry in
                        Color("primary")
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                VStack {
                                    Image("Logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    
                                    NavigationLink(destination: ChatBox()) {
                                        HStack {
                                            Text("Lets DUPElocate!")
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(10)
                                    }
                                    .padding()
                                }
                            )
                            .navigationBarHidden(true) // Hide the navigation bar
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            
        }
    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

