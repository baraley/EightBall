//
//  PresentableAnswerSet.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct PresentableAnswerSet: Equatable {

	static func == (lhs: PresentableAnswerSet, rhs: PresentableAnswerSet) -> Bool {
		return	lhs.id == rhs.id
	}

	let id: String
	var name: String
	var answers: [PresentableAnswer]

	init(id: String, name: String, answers: [PresentableAnswer] = []) {
		self.id = id
		self.name = name
		self.answers = answers
	}
}

extension PresentableAnswerSet {

	init(_ answerSet: AnswerSet) {
		let answers = answerSet.answers.map { PresentableAnswer($0) }
		self.init(id: answerSet.id, name: answerSet.name, answers: answers)
	}
}
