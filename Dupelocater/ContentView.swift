//
//  ContentView.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI
import CoreData

struct DrawerContent: View {
    var body: some View {
        NavigationView {
                    ZStack {
                        Color("primaryRed")
                            .ignoresSafeArea()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            //NavigationLink(destination: ProductCardPage ) { // Navigate to ProductsView
                                Text("Products!")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding()
                            //}
                            
                            Spacer()
                        }
                        .navigationBarHidden(true) // Hide the navigation bar
                    }
                }
    }
}

struct NavigationDrawer: View {
    private let width = UIScreen.main.bounds.width - 100
    @Binding var isOpen: Bool
    
    var body: some View {
        HStack {
            DrawerContent()
                .frame(width: self.width)
                .offset(x: self.isOpen ? 0 : -self.width)
                //.animation(.default)
            Spacer()
        }.onTapGesture {
            self.isOpen.toggle()
        }
    }
}

struct ContentView: View {
    @State var isDrawerOpen: Bool = false
    @ObservedObject var viewModel: ChatBox.ViewModel
    var body: some View {
        ZStack{
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
//                                NavigationLink(destination: ProductCardViews(viewModel: viewModel) ) {
//                                    HStack {
//                                        Text("Product Cards")
//                                            .fontWeight(.bold)
//                                            .foregroundColor(.white)
//                                    }
//                                    .padding()
//                                    .background(Color.red)
//                                    .cornerRadius(10)
//                                }
                                .padding()
                                
                            }
                        )
                        .navigationBarHidden(false) // Hide the navigation bar
//                        .navigationBarTitle(Text("Dupelocator"), displayMode: .inline)
//                        .navigationBarItems(leading: Button(action: {
//                                                self.isDrawerOpen.toggle()
//                                            }) {
//                                                Image(systemName: "sidebar.left")
//                                            })
                    
                }
            }
            NavigationDrawer(isOpen: self.$isDrawerOpen)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ChatBox.ViewModel()
        ContentView(viewModel: viewModel)
    }
}

