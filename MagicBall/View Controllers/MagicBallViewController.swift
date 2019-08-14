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
	
	var settingsModel: SettingsModel!  { didSet { settingsModelDidChange() } }
	
	var answerSetsModelController: AnswerSetsModelController! {
		didSet { answerSetsModelControllerDidChange() }
	}
	
	// MARK: - Outlets
	
	@IBOutlet private var magicBallView: MagicBallView!
	@IBOutlet private var sourceOptionsPickerView: UIPickerView!
	
	// MARK: - Private properties
	
	private let networkAnswersLoader: AnswerLoader = .init()
	private let textPronoucer: TextPronouncer = .init()
	
	private lazy var pickerViewConfigurator = createPickerViewConfigurator()
	
	private var answerSource: AnswerSource = .network
	
	// MARK: - UIResponder
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		requestNewAnswer()
	}
	
	// MARK: - Actions
	
	@IBAction private func requestNewAnswer() {
		guard magicBallView.isAnimationFinished == true else { return }
		
		magicBallView.state = .answerHidden
		textPronoucer.stopPronouncing()
		
		switch answerSource {
		case .network:						loadAnswerFromNetwork()
		case .customAnswers(let answers):	showAnswer(answers.randomElement() ?? "")
		}
	}
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		settingsModelDidChange()
		answerSetsModelControllerDidChange()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		textPronoucer.stopPronouncing()
	}
}

// MARK: - Private
private extension MagicBallViewController {
	
	// MARK: - Types
	
	enum AnswerSource {
		case network
		case customAnswers([String])
	}
	
	// MARK: - Configuration methods
	
	func settingsModelDidChange() {
		guard isViewLoaded else { return }
		
		magicBallView.isUserInteractionEnabled = settingsModel.lazyModeIsOn
	}
	
	func answerSetsModelControllerDidChange() {
		guard isViewLoaded else { return }
		
		let options = ["Answers form network"] + answerSetsModelController.answerSets.compactMap {
			$0.answers.isEmpty ? nil : $0.name
		}
		pickerViewConfigurator.optionsTitles = options
		sourceOptionsPickerView.reloadAllComponents()
	}
	
	func createPickerViewConfigurator() -> SingleComponentPickerViewConfigurator {
		let configurator = SingleComponentPickerViewConfigurator() { [weak self] (pickedIndex) in
			self?.setupAnswerSourceToPickeViewOption(at: pickedIndex)
		}
		sourceOptionsPickerView.dataSource = configurator
		sourceOptionsPickerView.delegate = configurator
		return configurator
	}
	
	func setupAnswerSourceToPickeViewOption(at index: Int) {
		if index == 0 {
			answerSource = .network
		} else if let answerSets = answerSetsModelController?.answerSets {
			answerSource = .customAnswers(answerSets[index - 1].answers)
		}
	}
	
	// MARK: - Answer showing
	
	func loadAnswerFromNetwork() {
		networkAnswersLoader.loadAnswer { [weak self] (result) in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				switch result {
				case .success(let answer):	self.showAnswer(answer)
				case .failure(let error):	self.showAlert(for: error)
				}
			}
		}
	}
	
	func showAnswer(_ answer: String) {
		if settingsModel.readAnswerIsOn {
			magicBallView.appearingAnimationDidFinishHandler = { [weak self] in
				self?.textPronoucer.pronounce(answer)
			}
		}
		
		magicBallView.state = .answerShown(answer)
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
