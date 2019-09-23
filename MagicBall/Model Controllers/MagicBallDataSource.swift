//
//  MagicBallDataSource.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/17/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class MagicBallDataSource: NSObject {
	
	typealias MagicBallResult = Result<String, NetworkError>
	
	var answerDidFindHandler: ((MagicBallResult) -> Void)?
	
	private let answerSets: [AnswerSet]
	private let networkAnswersLoader: AnswerLoader = .init()
	private var answersSource: AnswerSource = .network
	private lazy var pickerViewOptions: [String] = {
		return ["Answers form network"] + notEmptyAnswerSets().compactMap { $0.name }
	}()
	
	init(answerSets: [AnswerSet]) {
		self.answerSets = answerSets
		
		super.init()
	}
	
	func findNewAnswer() {
		switch answersSource {
		case .network:
			loadAnswerFromNetwork()
			
		case .customAnswers(let answers):
			let result: MagicBallResult = .success(answers.randomElement() ?? "")
			answerDidFindHandler?(result)
		}
	}
	
}

// MARK: - Private

private extension MagicBallDataSource {
	
	// MARK: - Types
	
	enum AnswerSource {
		case network
		case customAnswers([String])
	}
	
	// MARK: - Methods
	
	func notEmptyAnswerSets() -> [AnswerSet] {
		return answerSets.filter { !$0.answers.isEmpty }
	}
	
	func updateAnswerSourceToOption(at index: Int) {
		if index == 0 {
			answersSource = .network
		} else {
			answersSource = .customAnswers(notEmptyAnswerSets()[index - 1].answers)
		}
	}
	
	func loadAnswerFromNetwork() {
		networkAnswersLoader.loadAnswer { [weak self] (result) in
			guard let self = self else { return }
			
			DispatchQueue.main.async {
				self.answerDidFindHandler?(result)
			}
		}
	}
	
}

// MARK: - UIPickerViewDataSource

extension MagicBallDataSource: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerViewOptions.count
	}
	
}

// MARK: - UIPickerViewDelegate

extension MagicBallDataSource: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return pickerViewOptions[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateAnswerSourceToOption(at: row)
	}
	
}
