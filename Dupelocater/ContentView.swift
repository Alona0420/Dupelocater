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
        NavigationView{
//            VStack {
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Hello, world!")
//            }
            NavigationLink{
                ChatBox()
            } label:{
                HStack{
                    Text("Lets DUPElocate!")
                        .fontWeight(.bold)
                        .foregroundColor(.purple) 
                }
            }
        }
            .padding()
        }
    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

