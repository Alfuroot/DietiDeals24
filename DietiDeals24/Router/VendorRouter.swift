//
//  VendorRouter.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//


import Foundation
import SwiftUI

final class VendorRouter: RouterProtocol {
    static let shared = VendorRouter()
    
    public enum Destination: Hashable, Codable {
        case catalogDetail
    }
    
    @Published var navPath = NavigationPath()
    
    private init() {}
    
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
