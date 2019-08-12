//
//  MagicBallViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class MagicBallViewController: UIViewController {
	
	// MARK: - Public properties
	
	var settingsModel: SettingsModel! {
		didSet {
			if isViewLoaded { setup() }
		}
	}
	
	var answerSetsModelController: AnswerSetsModelController?
	
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
		
		prepareForAnswerShowing()
		
		showAnswerFromNetwork()
		
//		if settingsModel.onlyPredefinedAnswersModeIsOn {
//			showAnswer(randomPredefinedAnswer)
//		} else {
//			showAnswerFromNetwork()
//		}
	}
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
}

// MARK: - Private methods
private extension MagicBallViewController {
	
	var randomPredefinedAnswer: String {
		return answerSetsModelController?.answerSets[0].answers.randomElement() ?? "Hell yeah!!!"
	}
	
	func setup() {
		
		magicBallView.isUserInteractionEnabled = settingsModel.lazyModeIsOn
		
		generator.prepare()
	}
	
	func prepareForAnswerShowing() {
		
		magicBallView.state = .answerHidden
		
		textPronoucer.stopPronouncing()
		
		if settingsModel.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}
	}
	
	func showAnswer(_ answer: String) {
		if settingsModel.readAnswerIsOn {
			magicBallView.animationFinishedCompletionHandler = { [weak self] in
				self?.textPronoucer.pronounce(answer)
				self?.magicBallView.animationFinishedCompletionHandler = nil
			}
		}
		
		magicBallView.state = .answerShown(answer)
	}
	
	func showAnswerFromNetwork() {
		answerLoader.loadAnswer { [weak self] (optionAnswer) in
			guard let self = self else { return }
			
			let answer = optionAnswer ?? self.randomPredefinedAnswer
			
			DispatchQueue.main.async {
				
				self.showAnswer(answer)
			}
		}
	}
}
