//
//  SoundPlayer.swift
//  Noote
//
//  Created by Rahul choudhary on 15/04/25.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(name: String) {
    guard let url = Bundle.main.url(forResource: "sound-\(name)", withExtension: "mp3") else { return }
    
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    } catch {
        print("Error playing sound: \(error)")
    }
}
