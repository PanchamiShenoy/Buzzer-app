//
//  HostScreen.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/21/23.
//

import SwiftUI

struct HostScreen: View {
    @EnvironmentObject var screenEnvironmentObject: ScreenEnvironmentObject
    @State var devicesConncted: [String] = [String]()
    @State var playersBuzzed: [String] = [String]()
    @State private var showingAlert = false
    var multipeerService = MultipeerService.shared
    
    var body: some View {
        VStack{
            VStack {
                HStack() {
                    Text("GAME TIME")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        showingAlert = true
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 40,height: 40)
                            .foregroundColor(.white)
                        
                    }
                    .alert("Are you sure you want to quit?",isPresented: $showingAlert) {
                        Button("No", role: .cancel) {
                            
                        }
                        Button("Yes", role: .none) {
                            devicesConncted = []
                            multipeerService.clearConnectedDevices()
                            screenEnvironmentObject.screenToDisplay = 0
                        }
                    }
                    
                }
                .padding()
                
                GroupBox{
                    DisclosureGroup("Players Connected:   \(devicesConncted.count)") {
                        ForEach(0..<devicesConncted.count, id: \.self) { player in
                            Divider().padding(.vertical, 2)
                            Text(devicesConncted[player])
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background( LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)).opacity(0.6)
            
            List() {
                ForEach(playersBuzzed, id: \.self) { player in
                    Text(player)
                        .foregroundColor(.accentColor)
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(.clear)
            
            Button {
                playersBuzzed = []
                multipeerService.sendPermission()
            } label: {
                HStack{
                    Spacer()
                    Text("New Game")
                        .foregroundColor(.white)
                    Spacer()
                }
                
            }
            .padding()
            .background(Capsule().fill(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)))
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear() {
            self.multipeerService.hostDelegate = self
        }
    }
}

struct HostScreen_Previews: PreviewProvider {
    static var previews: some View {
        HostScreen()
    }
}

extension HostScreen : HostDelegate {
  
    func connectedDevicesChanged(manager: MultipeerService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.devicesConncted = connectedDevices
        }
    }
    func buzzerPressed(manager : MultipeerService, playerName: String) {
        playersBuzzed.append(playerName)
    }
}
