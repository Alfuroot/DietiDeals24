import SwiftUI

struct IBANModalView: View {
    @StateObject private var viewModel = IBANModalViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Inserisci il tuo IBAN")
                .font(.title)
                .padding()

            TextField("IBAN", text: $viewModel.iban)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.iban) { value in
                    viewModel.validateIBAN()
                }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                viewModel.confirmIBAN()
            }) {
                Text("Conferma")
                    .font(.headline)
                    .padding()
                    .background(viewModel.isIBANValid() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isIBANValid())

            Spacer()
        }
        .padding()
    }
}

#Preview {
    IBANModalView()
}
