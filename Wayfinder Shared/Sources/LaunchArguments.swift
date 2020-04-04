//
//  LaunchArguments.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 4/4/20.
//

import Foundation

enum LaunchArguments: String {
    case mockLocation = "MOCK_LOCATION"
    
    var isPresent: Bool {
        return ProcessInfo.processInfo.arguments.contains(self.rawValue)
    }
}
