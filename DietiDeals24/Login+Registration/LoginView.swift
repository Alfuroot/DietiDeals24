//
//  ContentView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject var router = LoginRouter()
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            ScrollView{
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("E-mail:")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        TextField("Enter your e-mail", text: $viewModel.email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                            .foregroundColor(.black)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                        
                        
                        Text("Password:")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                            .foregroundColor(.black)
                            .textContentType(.password)
                            .keyboardType(.default)
                        HStack {
                            Spacer()
                            VStack() {
                                Button(action: {
                                    viewModel.login()
                                }) {
                                    Text("Login")
                                        .padding()
                                        .background(viewModel.isLoginDisabled ? Color.gray : Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(viewModel.isLoginDisabled)
                                .padding(.bottom)
                                
                                if let errorMessage = viewModel.loginError {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding(.top, 8)
                                }
                                
                                Text("Don't have an account?")
                                Button( action: {
                                    router.navigate(to: .register)
                                
                                }, label: {
                                    Text("Register")
                                })
                                
                            }
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("DietiDeals24")
                .navigationDestination(for: LoginRouter.Destination.self) { destination in
                    switch destination {
                    case .register:
                        RegisterView()
                    case .login:
                        LoginView()
                    }
                }
            }
        }.environmentObject(router)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
