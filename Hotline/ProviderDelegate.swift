//
//  ProviderDelegate.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import AVFoundation
import CallKit

class ProviderDelegate: NSObject {
  private let callManager: CallManager
  private let provider: CXProvider
  
  init(callManager: CallManager) {
    self.callManager = callManager
    provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
    
    super.init()

    provider.setDelegate(self, queue: nil)
  }
  
  static var providerConfiguration: CXProviderConfiguration = {
    let providerConfiguration = CXProviderConfiguration(localizedName: "Hotline")
    
    providerConfiguration.maximumCallsPerCallGroup = 1
    providerConfiguration.supportedHandleTypes = [.generic]
    
    return providerConfiguration
  }()
  
  func reportIncomingCall(
    uuid: UUID,
    handle: String,
    completion: ((Error?) -> Void)?
  ) {
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
    
    provider.reportNewIncomingCall(with: uuid, update: update) { error in
      if error == nil {
        
        
        let call = Call(uuid: uuid, handle: handle)
        self.callManager.add(call: call)
      }
      
      completion?(error)
    }
  }
}

// MARK: - CXProviderDelegate
extension ProviderDelegate: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
    
    for call in callManager.calls {
      call.end()
    }
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    
    configureAudioSession()
    
    call.answer()

    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    
    call.end()

    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
    guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
      action.fail()
      return
    }
    
    call.state = action.isOnHold ? .held : .active
    
    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    let call = Call(uuid: action.callUUID, handle: action.handle.value)

    configureAudioSession()

    call.start { [weak self, weak call] success in
      guard
        let self = self,
        let call = call
        else {
          return
      }
      
      if success {
        action.fulfill()
        self.callManager.add(call: call)
      } else {
        action.fail()
      }
    }
  }
}
