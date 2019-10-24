//
//  MagicBallModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 01.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol AnswerPronouncer: class {

	func pronounce(_ answer: String)
	func stopPronouncing()
}

final class MagicBallModel {

	enum Change {
		case answerNumber(Int), answerLoaded(Answer?)
	}

	private let answerSourceModel: AnswerSourcesModel
	private let answerPronouncer: AnswerPronouncer
	private let answersCountingModel: AnswersCountingModel

	init (
		answerSourceModel: AnswerSourcesModel,
		answerPronouncer: AnswerPronouncer,
		answersCountingModel: AnswersCountingModel
	) {
		self.answerSourceModel = answerSourceModel
		self.answerPronouncer = answerPronouncer
		self.answersCountingModel = answersCountingModel

		answersCountingModel.answersNumberChangesHandler = { [weak self] number in
			self?.changesHandler?(.answerNumber(number))
		}
	}

	var loadedAnswersNumber: Int {
		return answersCountingModel.answersNumber
	}
	private(set) var answer: Answer? {
		didSet {
			changesHandler?(.answerLoaded(answer))
		}
	}
	var changesHandler: ((Change) -> Void)?

	func loadAnswer() {
		answerSourceModel.loadAnswer { [weak self] (answer) in
			self?.answersCountingModel.increase()
			self?.answer = answer
		}
	}

	func pronounceAnswer() {
		if let answer = answer {
			answerPronouncer.pronounce(answer.text)
		}
	}

	func stopPronouncing() {
		answerPronouncer.stopPronouncing()
	}
}
