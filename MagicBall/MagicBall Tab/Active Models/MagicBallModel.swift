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

	private let answerSourceModel: AnswerSourcesModel
	private let answerPronouncer: AnswerPronouncer

	init (answerSourceModel: AnswerSourcesModel, answerPronouncer: AnswerPronouncer) {

		self.answerSourceModel = answerSourceModel
		self.answerPronouncer = answerPronouncer
	}

	private(set) var answer: Answer? {
		didSet {
			answerDidChangeHandler?(answer)
		}
	}
	var answerDidChangeHandler: ((Answer?) -> Void)?

	func loadAnswer() {
		answerSourceModel.loadAnswer { [weak self] (answer) in
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
