//
//  LoginViewModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var isVendor: Bool = false
    @Published var isBuyer: Bool = false
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var showRegistrationErrorAlert: Bool = false
    
    var isLoginDisabled: Bool {
            return username.isEmpty || password.isEmpty
        }
    
    var isRegistrationValid: Bool {
        return !username.isEmpty && !email.isEmpty && !password.isEmpty && passwordConfirm == password
    }
    
    func toggleBuyer() {
        isVendor = false
        isBuyer.toggle()
    }

    func toggleVendor() {
        isBuyer = false
        isVendor.toggle()
    }
}
