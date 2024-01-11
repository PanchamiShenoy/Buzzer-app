//
//  StartGameView.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/22/23.
//

import SwiftUI
import MultipeerConnectivity

struct StartGameView: View {
    @EnvironmentObject var screenEnvironmentObject: ScreenEnvironmentObject
    @State var animation: Bool = false
    @State var username: String = ""
    @State var presentAlertHost = false
    @State var presentAlertPlayer = false
    var multipeerService = MultipeerService.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Text("LET'S  PLAY")
                .font(.headline)
                .opacity(animation ? 1 : 0)
                .animation(Animation.easeInOut(duration: 1.5), value: animation)
                .foregroundColor(.accentColor)
            
            VStack(spacing: 30) {
                Button {
                    presentAlertHost = true
                } label: {
                    Text("Host")
                        .padding(.horizontal, 20)
                }
                .alert("Enter Host Name", isPresented: $presentAlertHost) {
                    TextField("Host Name", text: $username)
                        .foregroundColor(.accentColor)
                    Button("Host") {
                        multipeerService.myPeerId = MCPeerID(displayName: username)
                        multipeerService.startHosting()
                        screenEnvironmentObject.screenToDisplay = 1
                    }
                    Button("Cancel", role: .cancel, action: {})
                        .foregroundColor(.red)
                }
                .padding()
                .background(
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                .foregroundColor(.white)
                .offset(y: animation ? 0 : -25)
                .opacity(animation ? 1 : 0.6)
                
                Button {
                    presentAlertPlayer = true
                    
                } label: {
                    Text("Player")
                        .padding(.horizontal)
                }
                .alert("Enter Player Name", isPresented: $presentAlertPlayer) {
                    TextField("Player Name", text: $username)
                        .foregroundColor(.accentColor)
                    Button("Join") {
                        multipeerService.myPeerId = MCPeerID(displayName: username)
                        multipeerService.joinSession()
                        screenEnvironmentObject.screenToDisplay = 2
                    }
                    Button("Cancel", role: .cancel, action: {})
                }
                .padding()
                .background(
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.indigo, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                .foregroundColor(.white)
                .offset(y: animation ? 0 : 25)
                .opacity(animation ? 1 : 0.6)
            }
            .animation(Animation.easeInOut(duration: 1.5), value: animation)
            .padding()
            .onAppear() {
                animation = true
            }
        }
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
