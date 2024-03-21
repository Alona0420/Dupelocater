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
        ZStack{
            //NavigationView {
                Color("primaryRed")
                //            Text("Lets DUPElocate!")
                //                .fontWeight(.bold)
                //                .foregroundColor(.white)
                //                .padding([.vertical], 65)
                            Text("Products!")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                
                //                    NavigationLink {
                //                        ChatBox()
                //                    } label: {
                //                        Text("Products")
                //                            .fontWeight(.bold)
                //                            .foregroundColor(.white)
                //                    }
               
            //} //ZStack
            
            
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
                            }
                        )
                        .navigationBarHidden(false) // Hide the navigation bar
                        .navigationBarTitle(Text("SwiftUI"), displayMode: .inline)
                        .navigationBarItems(leading: Button(action: {
                                                self.isDrawerOpen.toggle()
                                            }) {
                                                Image(systemName: "sidebar.left")
                                            })
                    
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
        ContentView()
    }
}

