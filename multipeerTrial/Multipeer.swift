//
//  Multipeer.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/22/23.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

protocol BuzzerScreenDelegate {
    func permissionChanged(manager: MultipeerService)
}

protocol HostDelegate {
    func connectedDevicesChanged(manager: MultipeerService, connectedDevices: [String])
    func buzzerPressed(manager: MultipeerService, playerName: String)
}


class MultipeerService : NSObject {
    @AppStorage("onboarding") var screenToDisplay: Int?
    public var myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var serviceAdvertiser : MCNearbyServiceAdvertiser?
    var buzzerDelegate : BuzzerScreenDelegate?
    var hostDelegate: HostDelegate?
    static let shared = MultipeerService()
    
    lazy var session : MCSession? = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        super.init()
    }
    
    func startHosting() {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        self.session = session
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: "buzzerApp")
        self.serviceAdvertiser?.delegate = self
        self.serviceAdvertiser?.startAdvertisingPeer()
    }
    
    func joinSession() {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        self.session = session
        let window = UIApplication.shared.windows.first
        let mcBrowser = MCBrowserViewController(serviceType: "buzzerApp", session: session ?? MCSession())
        mcBrowser.delegate = self
        window?.rootViewController?.present(mcBrowser, animated: true)
    }
    
    func send() {
        if session?.connectedPeers.count ?? 0 > 0 {
            do {
                try self.session?.send(session?.myPeerID.displayName.data(using: .utf8)! ?? Data(), toPeers: session?.connectedPeers ?? [], with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    func sendPermission() {
        if session?.connectedPeers.count ?? 0 > 0 {
            do {
                try self.session?.send("allow".data(using: .utf8)!, toPeers: session?.connectedPeers ?? [], with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    func clearConnectedDevices() {
        self.session?.disconnect()
        self.serviceAdvertiser?.stopAdvertisingPeer()
    }
}

extension MultipeerService : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

extension MultipeerService : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        self.hostDelegate?.connectedDevicesChanged(manager: self, connectedDevices:
                                                session.connectedPeers.map{$0.displayName})
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        if str == "allow" {
            self.buzzerDelegate?.permissionChanged(manager: self)
        }
        else {
            self.hostDelegate?.buzzerPressed(manager : self, playerName: str)
            
        }
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

extension MultipeerService: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        session?.disconnect()
        screenToDisplay = 0
        browserViewController.dismiss(animated: true)
    }
}
