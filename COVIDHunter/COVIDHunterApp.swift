//
//  COVIDHunterApp.swift
//  COVIDHunter
//
//  Created by Steven Yu on 1/29/22.
//

import SwiftUI

@main
struct COVIDHunterApp: App {
    
    // one StateObject vm so every object in hierarchy can access same vm class
    @StateObject private var vm: SimulationViewModel = SimulationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(StackNavigationViewStyle()) // prevents against iPad error
            .environmentObject(vm)
        }
    }
}
