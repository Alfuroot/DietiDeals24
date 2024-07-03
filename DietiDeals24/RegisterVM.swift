//
//  RegisterVM.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//

import Foundation

class RegisterVM: ObservableObject {
    @Published var isVendor: Bool = false
    @Published var isBuyer: Bool = false
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var showRegistrationErrorAlert: Bool = false
    
    var tmpuser: User?
    
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
    
    func creatUser() {
        tmpuser?.username = username
        tmpuser?.email = email
        tmpuser?.password = password
    }
}
