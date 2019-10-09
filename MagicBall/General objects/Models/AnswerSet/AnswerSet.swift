//
//  AnswerSet.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct AnswerSet: Equatable {

	static func == (lhs: AnswerSet, rhs: AnswerSet) -> Bool {
		return	lhs.id == rhs.id
	}

	let id: UUID
	var name: String
	var answers: [Answer]

	init(id: UUID = UUID(), name: String, answers: [Answer] = []) {
		self.id = id
		self.name = name
		self.answers = answers
	}

}

extension AnswerSet {

	init(from presentableAnswerSet: PresentableAnswerSet) {
		let answers = presentableAnswerSet.answers.map { Answer(from: $0) }
		self.init(id: presentableAnswerSet.id, name: presentableAnswerSet.name, answers: answers)
	}

	func toPresentableAnswerSet() -> PresentableAnswerSet {
		let presentableAnswers = answers.map { $0.toPresentableAnswer() }
		return PresentableAnswerSet(id: id, name: name, answers: presentableAnswers)
	}
}
