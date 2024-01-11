//
//  ContentView.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/21/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var screenEnvironmentObject: ScreenEnvironmentObject

    var body: some View {
        ZStack {
            if screenEnvironmentObject.screenToDisplay == 0 {
                StartGameView()
                
            } else if screenEnvironmentObject.screenToDisplay == 1 {
                HostScreen()
            }
            else {
                BuzzerUI()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
