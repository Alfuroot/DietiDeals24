import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @ObservedObject var router: LoginRouter
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Username:")
                        .fontWeight(.bold)
                    TextField("Enter your username", text: $viewModel.username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    Text("E-mail:")
                        .fontWeight(.bold)
                    TextField("Enter your e-mail", text: $viewModel.email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
                        .keyboardType(.emailAddress)

                    Text("Address:")
                        .fontWeight(.bold)
                    TextField("Enter your address", text: $viewModel.address)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    Text("Bio:")
                        .fontWeight(.bold)
                    TextField("Tell us about yourself", text: $viewModel.bio)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    Text("Codice Fiscale:")
                        .fontWeight(.bold)
                    TextField("Enter your codice fiscale", text: $viewModel.codicefisc)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    Text("Password:")
                        .fontWeight(.bold)
                    SecureField("Enter your password", text: $viewModel.password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    Text("Confirm Password:")
                        .fontWeight(.bold)
                    SecureField("Confirm your password", text: $viewModel.passwordConfirm)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))

                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                await viewModel.registerUser()
                            }
                        }) {
                            Text("Register")
                                .padding()
                                .background(viewModel.isRegistrationDisabled ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isRegistrationDisabled)
                        Spacer()
                    }

                    if let errorMessage = viewModel.registrationError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                }
                .padding()
                .navigationTitle("Registrazione")
                .alert(isPresented: $viewModel.showRegistrationSuccessAlert) {
                    Alert(
                        title: Text("Congratulazioni!"),
                        message: Text("Registrazione avvenuta con successo."),
                        dismissButton: .default(Text("Ok"), action: {
                            router.navigateBack()
                        })
                    )
                }
            }
        }
}
