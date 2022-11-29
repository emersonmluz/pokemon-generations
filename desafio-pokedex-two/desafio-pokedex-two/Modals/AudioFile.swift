//
//  AudioFile.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 29/11/22.
//

import UIKit
import AVFoundation

class AudioFile {
    static func importAudioFile () -> AVAudioPlayer {
        var audioFileResult: AVAudioPlayer?
        do {
            let path = Bundle.main.path(forResource: "pokemonTheme", ofType: "mp3")
            let audioFile = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            audioFileResult = audioFile
        } catch {
            print("Arquivo de áudio não encontrado.")
        }
        return audioFileResult!
    }
    
}
