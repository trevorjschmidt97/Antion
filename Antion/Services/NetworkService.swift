//
//  NetworkService.swift
//  Antion
//
//  Created by Trevor Schmidt on 4/3/22.
//

import Foundation
import Network

struct NetworkService {
    private init() { }
    static let shared = NetworkService()
    
    func test() {
    }
}

class Connect: NSObject {
    private var talking: NWConnection?
    private var listening: NWListener?
    
    func listenUDP(port: NWEndpoint.Port) {
        do {
            self.listening = try NWListener(using: .udp, on: port)
            self.listening?.stateUpdateHandler = { (newState) in
                switch newState {
                    case .ready:
                        print("ready")
                    default:
                        break
                    }
            }
            self.listening?.newConnectionHandler = { (newConnection) in
                newConnection.stateUpdateHandler = { newState in
                    switch newState {
                        case .ready:
                            print("new connection")
                            self.receive(on: newConnection)
                        default:
                            break
                    }
                }
                newConnection.start(queue: DispatchQueue(label: "new client"))
            }
        } catch {
            print("unable to create listener")
        }
        self.listening?.start(queue: .main)
    }
    
    func receive(on connection: NWConnection) {
        connection.receiveMessage { (data, context, isComplete, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data, !data.isEmpty {
                let backToString = String(decoding: data, as: UTF8.self)
                print("b2S",backToString)
            }
        }
    }
}
