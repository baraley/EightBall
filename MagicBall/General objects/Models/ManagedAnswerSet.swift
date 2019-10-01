//
//  AnswerSet.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class ManagedAnswerSet: Codable, Equatable {

	static func == (lhs: ManagedAnswerSet, rhs: ManagedAnswerSet) -> Bool {
		return	lhs.id == rhs.id
	}

	let id: UUID
	var name: String
	var answers: [String]

	init(id: UUID = .init(), name: String, answers: [String]) {
		self.id = id
		self.name = name
		self.answers = answers
	}

}

extension ManagedAnswerSet {

	convenience init(from answerSet: AnswerSet) {

		self.init(id: answerSet.id, name: answerSet.name, answers: answerSet.answers)
	}

	func toAnswerSet() -> AnswerSet {

		return AnswerSet(id: id, name: name, answers: answers)
	}
}
