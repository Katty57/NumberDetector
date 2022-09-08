//
//  Audio.swift
//  NumberDetector
//
//  Created by  User on 08.09.2022.
//

import AVFoundation

func configureAudioSession() {
  let session = AVAudioSession.sharedInstance()
  do {
    try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
  } catch (let error) {
    print("Error while configuring audio session: \(error)")
  }
}
