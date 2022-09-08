//
//  AppDelegate.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let callManager = CallManager()
  var providerDelegate: ProviderDelegate!
  
  class var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    providerDelegate = ProviderDelegate(callManager: callManager)
    return true
  }
  
  func displayIncomingCall(
    uuid: UUID,
    handle: String,
    completion: ((Error?) -> Void)?
  ) {
    providerDelegate.reportIncomingCall(
      uuid: uuid,
      handle: handle,
      completion: completion)
  }
}
