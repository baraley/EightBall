//
//  MagicBallViewController.swift
//  MagicBall
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
	
	var answerSetsModelController: AnswerSetsModelController? {
		didSet {
			if isViewLoaded { setup() }
		}
	}
	
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
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		textPronoucer.stopPronouncing()
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
		
		pickerViewConfigurator = createPickerViewConfigurator()
	}
	
	var pickerViewOptions: [String] {
		var options = ["Answers form network"]
		if let answersSets = answerSetsModelController?.answerSets {
			options += answersSets.compactMap { $0.answers.isEmpty ? nil : $0.name }
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
		networkAnswersLoader.loadAnswer { [weak self] (result) in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				
				switch result {
				case .success(let answer):
					self.showAnswer(answer)
					
				case .failure(let error):
					self.showAlert(for: error)
				}
			}
		}
	}
	
	func showAlert(for error: NetworkError) {
		
		let alertMessage: String = error.errorDescription
		
		let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
			self.magicBallView.state = .initialMessage("Shake your phone, please!!!")
		})
		
		self.present(alert, animated: true, completion: nil)
	}
}
