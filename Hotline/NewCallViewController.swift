//
//  NewCallViewController.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import UIKit

class NewCallViewController: UIViewController {
  var handle: String? {
    return handleTextField.text
  }
  
    @IBOutlet weak var handleTextField: UITextField!
}

