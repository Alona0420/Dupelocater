//
//  ProductCardPage.swift
//  Dupelocater
//
//  Created by Jayla Scott on 3/20/24.
//

import SwiftUI

struct ProductCardPage: View {
    var productCards: [ProductCard]
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        ScrollView {
                    VStack(spacing: 10) {
                        ForEach(productCards, id: \.productName) { card in
                            ProductCardView(productCard: card)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Product Cards")
    }
}

struct ProductCardView: View {
    let productCard: ProductCard
    
    var body: some View {
        VStack {
            Text(productCard.productName)
            Text("\(productCard.price)")
            // Display image, URL, and other details as needed
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        //.shadow(radius: 5)
        .padding()
    }
}

//struct ProductCardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCardPage()
//    }
//}

struct ProductCardPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCards = [
            ProductCard(productName: "Sample Product 1", price: 9.99, uRL: URL(string: "https://example.com")!),
            ProductCard(productName: "Sample Product 2", price: 19.99, uRL: URL(string: "https://example.com")!)
        ]
        ProductCardPage(productCards: sampleCards)
    }
}
