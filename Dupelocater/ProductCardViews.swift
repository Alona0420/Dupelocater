//
//  ProductCardViews.swift
//  Dupelocater
//
//  Created by Jayla Scott on 4/10/24.
//

import SwiftUI

struct ProductCards: Identifiable {
    let id: UUID
    let name: String
    let imageURL: URL
    let cost: Double
    // Add other properties as needed
    
    init(name: String, imageURL: URL, cost: Double) {
        self.id = UUID()
        self.name = name
        self.imageURL = imageURL
        self.cost = cost
    }
}

class ProductNetworking {
    func fetchProductData(completion: @escaping ([ProductCards]) -> Void) {
        // Simulated data for demonstration purposes
        let products = [
            ProductCards(name: "Product 1", imageURL: URL(string: "https://example.com/image1.jpg")!, cost: 19.99),
            ProductCards(name: "Product 2", imageURL: URL(string: "https://example.com/image2.jpg")!, cost: 29.99),
            ProductCards(name: "Product 3", imageURL: URL(string: "https://example.com/image3.jpg")!, cost: 39.99),
            // Add more products as needed
        ]
        
        completion(products)
    }
}



struct ProductCardView2: View {
    let product: ProductCards
    
    var body: some View {
        VStack {
            Text(product.name)
                .font(.headline)
            Image(systemName: "photo") // Placeholder image
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                .padding(.vertical, 8)
            Text("$\(product.cost)")
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}


struct ProductCardViews: View {
    @ObservedObject var viewModel: ChatBox.ViewModel
    @State private var products: [ProductCards] = []
    let productNetworking = ProductNetworking()
    
    var body: some View {
        ZStack{
            Color("primary")
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(products) { product in
                        ProductCardView2(product: product)
                    }
                }
                .padding()
            }
            .onAppear {
                //                    productNetworking.fetchProductData { products in
                //                        self.products = products
                //                    }
                fetchAndProcessAPIResponse()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    private func fetchAndProcessAPIResponse() {
        // Simulated response for demonstration purposes
        //            let response = """
        //            **Product 1
        //               Description: Some description here
        //               Price: $19.99
        //           **Product 2
        //               Description: Another description here
        //              Price: $29.99
        //           """
        //        //let response = try await viewModel.sendChat(chat: chat)
        //            // Call the parseAPIResponse function to parse the response and update products
        //        let parsedProducts = viewModel.parseAPIResponse(response: response)
        //            self.products = parsedProducts
        //        }
        
        Task {
            do {
                try await viewModel.sendChat { success in
                    if success, let response = viewModel.response {
                        // Pass the received message content to parseAPIResponse
                        let parsedProductCards = viewModel.parseAPIResponse(response: response)
                        DispatchQueue.main.async {
                            self.products = parsedProductCards
                        }
                    } else {
                        print("Error: Failed to send chat or no response received")
                    }
                }
            } catch {
                print("Error fetching and processing API response: \(error)")
            }
        }
    }
    
    
    
    
    struct ProductCardViews_Previews: PreviewProvider {
        static var previews: some View {
            //        ProductCardViews()
            let viewModel = ChatBox.ViewModel()
            return ProductCardViews(viewModel: viewModel)
        }
    }
    
}
