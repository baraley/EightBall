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
	
	private var pickerViewOptions: [String] = []
	
	private var answersSource: AnswerSource = .network
	
	// MARK: - UIResponder
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		requestNewAnswer()
	}
	
	// MARK: - Actions
	
	@IBAction private func requestNewAnswer() {
		guard magicBallView.isAnimationFinished == true else { return }
		
		magicBallView.state = .answerHidden
		textPronoucer.stopPronouncing()
		
		switch answersSource {
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
		
		pickerViewOptions = ["Answers form network"] + answerSetsModelController.answerSets.compactMap {
			$0.answers.isEmpty ? nil : $0.name
		}
		sourceOptionsPickerView.reloadAllComponents()
		
		let selectedIndex = sourceOptionsPickerView.selectedRow(inComponent: 0)
		setupAnswerSourceToPickeViewOption(at: selectedIndex)
	}
	
	func setupAnswerSourceToPickeViewOption(at index: Int) {
		if index == 0 {
			answersSource = .network
		} else if let answerSets = answerSetsModelController?.answerSets {
			answersSource = .customAnswers(answerSets[index - 1].answers)
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

// MARK: - UIPickerViewDataSource
extension MagicBallViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerViewOptions.count
	}
}

// MARK: - UIPickerViewDelegate
extension MagicBallViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView,
					titleForRow row: Int,
					forComponent component: Int) -> String? {
		
		return pickerViewOptions[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		setupAnswerSourceToPickeViewOption(at: row)
	}
}
