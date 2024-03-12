//
//  SwipingFeature.swift
//  Dupelocater
//
//  Created by Sarah Orji on 2/21/24.
//

import SwiftUI

//struct SwipingFeature: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//struct SwipingFeature: View {
//    @Binding var results: [String]
//    
//    var body: some View {
//        ZStack {
//            ForEach(results, id: \.self) { result in
//                CardView(content: result)
//                    .padding()
//            }
//        }
//        .onAppear {
//                    print("Results received: \(results)")
//                }
//    }
//    
//}
//struct SwipingFeature: View {
//    @Binding var results: [String]
//    @State private var isResultsEmpty = true // Track if results is empty
//    
//    var body: some View {
//        if !results.isEmpty {
//            ZStack {
//                ForEach(results, id: \.self) { result in
//                    CardView(content: result)
//                        .padding()
//                }
//            }
////            .onReceive(results.publisher) { _ in // Listen for changes to results
////                           print("Results received in SwipingFeature:", results)
////                           isResultsEmpty = results.isEmpty // Update isResultsEmpty based on results
////                       }
//        
////
//            
//            
//        } else {
//            // Optionally, you can display a placeholder or loading indicator here
//            Text("Loading...")
//        }
//    }
//    
//}
struct SwipingFeature: View {
    @Binding var results: [String]
    @State private var observedResults: [String] = []

    var body: some View {
        ZStack {
            if !observedResults.isEmpty {
                ForEach(observedResults, id: \.self) { result in
                    CardView(content: result)
                        .padding()
                }
            } else {
                // Optionally, you can display a placeholder or loading indicator here
                Text("Loading...")
            }
        }
        
//        ZStack {
//            if !results.isEmpty {
//                Text("Swiping Feature")
//            }
////                   } else {
////                       Text("Loading...")
////                   }
//               }
        .onAppear {
            observedResults = results
        }
        .onChange(of: results) { newResults in
            observedResults = newResults
        }
    }
}






//#Preview {
//    SwipingFeature()
//}
