//
//  CallManager.swift
//  Runner
//
//  Created by Donnukrit Satirakul on 26/12/2566 BE.
//

import CallKit
import Foundation

@available(iOS 14.0, *)
final class CallManager: NSObject, CXProviderDelegate {
    let provider: CXProvider = .init(configuration: CXProviderConfiguration())
    let callController = CXCallController()

    override init() {
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    public func reportIncomingCall(id: UUID, handle: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print(String(describing: error))
            } else {
                print("Report Call")
            }
        }
    }

    public func startCall(id: UUID, handle: String) {
        let handle = CXHandle(type: .generic, value: handle)
        let action = CXStartCallAction(call: id, handle: handle)
        let transaction = CXTransaction(action: action)

        callController.request(transaction) { error in
            if let error = error {
                print(String(describing: error))
            } else {
                print("Start Call")
            }
        }
    }

    func providerDidReset(_ provider: CXProvider) {}
}
