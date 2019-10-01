//
//  AnswerSourceViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class AnswerSourceViewModel {

	private let answerSourceModel: AnswerSourcesModel

	init(answerSourceModel: AnswerSourcesModel) {
		self.answerSourceModel = answerSourceModel

		answerSourceModel.answerSetsDidChangeHandler = {  [weak self] in
			self?.answerSourceOptionsDidChangeHandler?()
		}
		answerSourceModel.loadAnswerSets()
	}

	var answerSourceOptionsDidChangeHandler: (() -> Void)?

	var numberOfOptions: Int {
		return answerSourceModel.numberOfAnswerSets() + 1
	}

	func optionTitle(at index: Int) -> String {
		if index == 0 {
			return L10n.networkAnswerSourceTitle
		} else {
			return answerSourceModel.answerSet(at: index - 1).name
		}
	}

	func didSelectOption(at index: Int) {
		if index == 0 {
			answerSourceModel.answerSource = .network
		} else {
			answerSourceModel.answerSource = .answerSet(index - 1)
		}
	}

}
