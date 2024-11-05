//
//  LoginRouter.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//

import Foundation
import SwiftUI

final class LoginRouter: RouterProtocol {
    
    public enum Destination: Hashable, Codable {
        case login
        case register
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
