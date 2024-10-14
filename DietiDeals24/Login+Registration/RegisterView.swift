import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationView {
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
                            viewModel.registerUser()
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
                .navigationTitle("Register")
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
