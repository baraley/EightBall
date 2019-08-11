//
//  MagicBallViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit
import AVFoundation

class MagicBallViewController: UIViewController {
	
	// MARK: - Public properties
	
	var settingsModel: SettingsModel! {
		didSet {
			setup()
		}
	}
	
	// MARK: - Outlets
	
	@IBOutlet private var magicBallView: MagicBallView!
	
	// MARK: - Private properties
	
	private let answerLoader: AnswerLoader = .init()
	
	private let textPronoucer: TextPronouncer = .init()
	
	private lazy var generator: UINotificationFeedbackGenerator = .init()
	
	// MARK: - UIResponder
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		requestNewAnswer()
	}
	
	// MARK: - Actions
	
	@IBAction private func requestNewAnswer() {
		guard magicBallView.isAnimationFinished == true else { return }
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		if settingsModel.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}
		
		textPronoucer.stopPronouncing()
		
		magicBallView.state = .loadingAnswer
		
		answerLoader.loadAnswer { [weak self] (answer) in
			guard let self = self else {
				return
			}
			
			let answer = answer ?? "Hell yeah!!!"
			
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				
				if self.settingsModel.readAnswerIsOn {
					self.textPronoucer.pronounce(answer)
				}
				
				self.magicBallView.state = .showingAnswer(answer)
			}
		}
	}
	
	// MARK: - Helpers
	
	private func setup() {
		
		magicBallView.isUserInteractionEnabled = settingsModel.lazyModeIsOn
		
		generator.prepare()
	}
}
