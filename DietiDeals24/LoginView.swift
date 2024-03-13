//
//  ContentView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView{
                Text("State your purpose:")
                    .fontWeight(.bold)
                    .font(.title)
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.toggleBuyer()
                    }, label: {
                            Text("Buy")
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.height * 0.05)
                                .background(viewModel.isBuyer ? Color.blue : Color.gray)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        })
                    
                    Button(action: {
                        viewModel.toggleVendor()
                    }, label: {
                        Text("Sell")
                            .frame(maxWidth: .infinity)
                            .frame(height: UIScreen.main.bounds.height * 0.05)
                            .background(viewModel.isVendor ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    })
                }.padding(.horizontal)
                VStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Username:")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        TextField("Enter your username", text: $viewModel.username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                            .foregroundColor(.black)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                        
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
                        
                        Text("Confirm password:")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        SecureField("Confirm your password", text: $viewModel.passwordConfirm)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                            .foregroundColor(.black)
                            .textContentType(.password)
                            .keyboardType(.default)
                        HStack {
                            Spacer()
                            VStack() {
                                
                                NavigationLink(destination: {
                                    
                                }, label: {
                                    Text("Register")
                                })
                                .padding(.bottom)
                                .disabled(!viewModel.isRegistrationValid)
                                Text("Already have an account?")
                                NavigationLink(destination: {
                                    //                                    Task {
                                    //                                        do {
                                    //                                            let registrationSuccess = try await viewModel.registerUser()
                                    //                                            if registrationSuccess {
                                    //                                                // Navigate to the appropriate destination upon successful registration
                                    //                                                if viewModel.isBuyer {
                                    //                                                    BuyerView()
                                    //                                                } else if viewModel.isVendor {
                                    //                                                    // Handle vendor navigation
                                    //                                                }
                                    //                                            } else {
                                    //                                                // Show an alert if registration fails
                                    //                                                viewModel.showRegistrationErrorAlert = true
                                    //                                            }
                                    //                                        } catch {
                                    //                                            // Handle errors, e.g., network issues
                                    //                                            viewModel.showRegistrationErrorAlert = true
                                    //                                        }
                                    //                                    }
                                }, label: {
                                    Text("Login")
                                })
                                
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            Spacer()
                            Image("google_logo.png")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding()
                            
                            Image("github_logo.png")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                            
                            Image("apple_logo.png")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("DietiDeals24")
            }
        }
        .environmentObject(viewModel)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
