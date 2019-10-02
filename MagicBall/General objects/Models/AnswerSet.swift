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
	var answers: [String]

	init(id: UUID = .init(), name: String, answers: [String] = []) {
		self.id = id
		self.name = name
		self.answers = answers
	}

}
