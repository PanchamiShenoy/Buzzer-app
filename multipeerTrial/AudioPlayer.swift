//
//  AudioPlayer.swift
//  multipeerTrial
//
//  Created by Panchami Shenoy on 6/21/23.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
func playSound(sound: String, type: String) {
    if let path = Bundle.main.url(forResource: sound, withExtension: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.play()
        } catch {
            print("Could not play the sound file.")
        }
    }
    else {
        print("\n\n error")
    }
}
