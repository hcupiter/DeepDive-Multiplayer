//
//  MPConnectionManager.swift
//  DivingGame
//
//  Created by Hans Arthur Cupiterson on 30/04/24.
//

import MultipeerConnectivity
import SwiftUI

extension String {
    static var serviceName = "DivingGame"
}

// NSObject because Multipeer connectivity is an objective-c language
class MPConnectionManager: NSObject, ObservableObject {
    @Published var matchManager: MatchManager!
    
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    
    // list of available peer
    @Published var listAvailablePeers: [MCPeerID] = []
    
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)? // callback function if received invitation
    @Published var paired: Bool = false
    
    // to broadcast your phone to another player
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    
    // to be able to search for another player
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    
    // make an observer here, if the value changes it will run the code in the block
    var isAvailableToPlay: Bool = false {
        didSet {
            if isAvailableToPlay {
                startAdvertising()
            }
            else {
                stopAdvertising()
            }
        }
    }
    
    init(playerId: UUID){
        self.myPeerId = MCPeerID(displayName: playerId.uuidString)
        self.session = MCSession(peer: myPeerId)
        self.nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        self.nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    // if the class happens to destroyed, it calls this function
    deinit {
        stopAdvertising()
        stopBrowsing()
    }
    
    func startAdvertising(){
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising(){
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing(){
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing(){
        nearbyServiceBrowser.stopBrowsingForPeers()
        listAvailablePeers.removeAll() // remove all data if stop browsing
    }
    
    func setupGame(matchManager: MatchManager){
        self.matchManager = matchManager
        self.matchManager.connectionManager = self
    }
    
    func send(gameEvent: MPGameEvent){
        if session.connectedPeers.isEmpty == false {
            do {
                if let data = gameEvent.data() {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            }
            catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// make extension of the class to find others to play
extension MPConnectionManager: MCNearbyServiceBrowserDelegate {
    // function that will be called if found someone advertising
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            // only add to list available peers if not in the list
            if self.listAvailablePeers.contains(peerID) == false {
                self.listAvailablePeers.append(peerID)
            }
        }
    }
    
    // function that will be called if someone stop advertising
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // check if someone is not in available peers, it will return
        guard let index = listAvailablePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.listAvailablePeers.remove(at: index)
        }
    }
}

extension MPConnectionManager: MCNearbyServiceAdvertiserDelegate {
    // this function will be called if the user received invitation
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension MPConnectionManager: MCSessionDelegate {
    // this function will handle connection
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .notConnected:
                DispatchQueue.main.async {
                    self.paired = false
                    self.isAvailableToPlay = true
                }
            case .connected:
                DispatchQueue.main.async {
                    self.paired = true
                    self.isAvailableToPlay = false
                }
            default:
                DispatchQueue.main.async {
                    self.paired = false
                    self.isAvailableToPlay = true
                }
            }
    }
    
    // this function will handle receiving data
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameEvent = try? JSONDecoder().decode(MPGameEvent.self, from: data) {
            DispatchQueue.main.async {
                self.matchManager.handleGameEvent(gameEvent: gameEvent, connectionManager: self)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
    
    
}
