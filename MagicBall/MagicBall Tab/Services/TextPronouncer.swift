//
//  TextPronouncer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/10/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import AVFoundation

final class TextPronouncer {

	private var speechSynthesizer: AVSpeechSynthesizer = {
		let audioSession = AVAudioSession.sharedInstance()
		try? audioSession.setCategory(AVAudioSession.Category.ambient, options: [.duckOthers])
		return AVSpeechSynthesizer()
	}()

	func pronounce(_ text: String) {
		guard !text.isEmpty else { return }
		let utterance = AVSpeechUtterance(string: text)
		let voice = AVSpeechSynthesisVoice.speechVoices().first {
			$0.identifier == "com.apple.ttsbundle.Samantha-premium"
		}
		utterance.voice = voice ?? AVSpeechSynthesisVoice(language: "en-US")
		stopPronouncing()
		speechSynthesizer.speak(utterance)
	}

	func stopPronouncing() {
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: .immediate)
		}
	}

}
