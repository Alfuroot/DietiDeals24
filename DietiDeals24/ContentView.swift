//
//  ContentView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var isVendor: Bool = false
    @State var isBuyer: Bool = false
    var body: some View {
        NavigationStack{
            
            VStack {
                HStack{
                    Button(action: {
                        isVendor.toggle()
                        if isBuyer {
                            isBuyer.toggle()
                        }
                    }, label: {
                        Image("seller")
                            .resizable()
                            .scaledToFit()
                            .grayscale(isVendor ? 0 : 1)
                            
                    })
                    Button(action: {
                        isBuyer.toggle()
                        if isVendor {
                            isVendor.toggle()
                        }
                    }, label: {
                        Image("buyer")
                            .resizable()
                            .scaledToFit()
                            .grayscale(isBuyer ? 0 : 1)
                    })
                }
                NavigationLink(destination: {
                    LoginView()
                } , label: {
                    Text("Login")
                })
            }
            .padding()
        }
    }
}


