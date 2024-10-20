//
//  VendorRouter.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//


import Foundation
import SwiftUI

final class DashboardRouter: RouterProtocol {
    static let shared = DashboardRouter()
    
    public enum Destination: Hashable, Codable {
        case itemDetail
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
