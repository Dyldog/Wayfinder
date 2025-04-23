//
//  File.swift
//  
//
//  Created by Dylan Elliott on 23/4/2025.
//

import SwiftUI

public struct Wayfinder: UIViewRepresentable {
    let destination: Headable
    let onUpdate: (UserLocationManager) -> Void
    
    public init(destination: Headable, onUpdate: @escaping (UserLocationManager) -> Void = { _ in }) {
        self.destination = destination
        self.onUpdate = onUpdate
    }
    
    public func makeUIView(context: Context) -> WayfinderView {
        let view = WayfinderView()
        view.destination = destination
        context.coordinator.locationManager = view.locationManager
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: WayfinderView, context: Context) {
        uiView.destination = destination
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: WayfinderViewDelegate {
        let parent: Wayfinder
        var locationManager: UserLocationManager!
        
        init(_ parent: Wayfinder) {
            self.parent = parent
        }
        
        public func wayfinderViewDidUpdate() {
            parent.onUpdate(locationManager)
        }
    }
}

#Preview {
    Wayfinder(destination: FinderPlace(
        name: "Test",
        address: "123 Fake Street",
        location: .init(
            latitude: 34, longitude: 166)
    ))
}
