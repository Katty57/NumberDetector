//
//  ViewController.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import UIKit

private let presentIncomingCallViewControllerSegue = "PresentIncomingCallViewController"
private let callCellIdentifier = "CallCell"

class CallsViewController: UITableViewController {
  var callManager: CallManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    callManager = AppDelegate.shared.callManager
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    
    callManager.callsChangedHandler = { [weak self] in
      guard let self = self else { return }
      self.tableView.reloadData()
    }
  }
  
  @IBAction private func unwindForNewCall(_ segue: UIStoryboardSegue) {
    guard
      let newCallController = segue.source as? NewCallViewController,
      let handle = newCallController.handle
      else {
        return
    }
    
    let backgroundTaskIdentifier =
      UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      AppDelegate.shared.displayIncomingCall(
        uuid: UUID(),
        handle: handle
      ) { _ in
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension CallsViewController {
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return callManager.calls.count
  }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let call = callManager.calls[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: callCellIdentifier)
      as! CallTableViewCell
    cell.callerHandle = call.handle
    cell.time = call.time
    return cell
  }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    let call = callManager.calls[indexPath.row]
    callManager.end(call: call)
  }
}

// MARK - UITableViewDelegate
extension CallsViewController {
  override func tableView(
    _ tableView: UITableView,
    titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath
  ) -> String? {
    return "End"
  }
}
