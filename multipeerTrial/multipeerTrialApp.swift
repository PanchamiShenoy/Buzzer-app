//
//  multipeerTrialApp.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/21/23.
//

import SwiftUI

class ScreenEnvironmentObject: ObservableObject {
  @Published var screenToDisplay = 0
}

@main
struct multipeerTrialApp: App {
    @StateObject private var screenEnvironmentObject = ScreenEnvironmentObject()
    
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(screenEnvironmentObject)
    }
  }
}
