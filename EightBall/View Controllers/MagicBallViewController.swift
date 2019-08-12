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
	@IBOutlet private var answerSetPicker: UIPickerView!
	
	// MARK: - Private properties
	
	private var pickerViewConfigurator: SingleComponentPickerViewConfigurator?
	
	private var answerSource: AnswerSource = .network
	
	private let networkAnswersLoader: AnswerLoader = .init()
	
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
		
		switch answerSource {
		case .network:
			showAnswerFromNetwork()
		case .customAnswers(let answers):
			showAnswer(answers.randomElement() ?? "")
		}
	}
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		pickerViewConfigurator = createPickerViewConfigurator()
	}
}

// MARK: - Private methods
private extension MagicBallViewController {
	
	// MARK: - Types
	
	enum AnswerSource {
		case network
		case customAnswers([String])
	}
	
	// MARK: - Methods
	
	func setup() {
		
		magicBallView.isUserInteractionEnabled = settingsModel.lazyModeIsOn
		
		if settingsModel.hapticFeedbackIsOn {
			generator.prepare()
		}
	}
	
	var pickerViewOptions: [String] {
		var options = ["Answers form network"]
		if let answersSets = answerSetsModelController?.answerSets {
			options += answersSets.map { $0.name }
		}
		return  options
	}
	
	func createPickerViewConfigurator() -> SingleComponentPickerViewConfigurator {
		
		let configurator = SingleComponentPickerViewConfigurator(optionsTitles: pickerViewOptions) {
			[weak self] (pickedIndex) in
			
			self?.setupAnswerSourceToPickeViewOption(at: pickedIndex)
		}
		answerSetPicker.dataSource = configurator
		answerSetPicker.delegate = configurator
		
		return configurator
	}
	
	func setupAnswerSourceToPickeViewOption(at index: Int) {
		if index == 0 {
			answerSource = .network
		} else if let answerSets = answerSetsModelController?.answerSets {
			
			answerSource = .customAnswers(answerSets[index - 1].answers)
		}
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
		networkAnswersLoader.loadAnswer { [weak self] (optionAnswer) in
			guard let self = self else { return }
			
			let answer = optionAnswer ?? "Hell "
			
			DispatchQueue.main.async {
				
				self.showAnswer(answer)
			}
		}
	}
}
