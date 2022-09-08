//
//  Call.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import Foundation

enum CallState {
  case connecting
  case active
  case held
  case ended
}

enum ConnectedState {
  case complete
}

class Call {
  let uuid: UUID
  let handle: String
  let time: String
  
  var state: CallState = .ended {
    didSet {
      stateChanged?()
    }
  }
  
  var stateChanged: (() -> Void)?
  
  init(uuid: UUID, handle: String) {
    self.uuid = uuid
    self.handle = handle
    
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    let resultHour = hour > 9 ? "\(hour)" : "0\(hour)"
    let resultMinutes = minutes > 9 ? "\(minutes)" : "0\(minutes)"
    self.time = "\(resultHour):\(resultMinutes)"
  }
  
  func start(completion: ((_ success: Bool) -> Void)?) {
    completion?(true)

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.state = .connecting
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.state = .active
      }
    }
  }
  
  func answer() {
    state = .active
  }
  
  func end() {
    state = .ended
  }
}
