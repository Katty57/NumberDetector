//
//  CallTableViewCell.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import UIKit

class CallTableViewCell: UITableViewCell {
  
  var callerHandle: String? {
    didSet {
      callerHandleLabel.text = callerHandle
    }
  }
  
  var time: String? {
    didSet {
      timeLabel.text = time
    }
  }
  
  var callerId: String? {
    didSet {
      callerIdLabel.text = callerId
    }
  }
    
    @IBOutlet weak var callerHandleLabel: UILabel!
    @IBOutlet weak var callerIdLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}
