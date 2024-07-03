//
//  RouterProtocol.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//

import Foundation

import SwiftUI

protocol RouterProtocol: ObservableObject {
    associatedtype Destination: Codable
    
    var navPath: NavigationPath { get set }
    
    func navigate(to destination: Destination)
    func navigateBack()
    func navigateToRoot()
}
