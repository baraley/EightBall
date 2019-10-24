//
//  AnswerSet.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct AnswerSet: Equatable, Codable, Identifiable {

	static func == (lhs: AnswerSet, rhs: AnswerSet) -> Bool {
		return	lhs.id == rhs.id
	}

	let id: String
	var name: String
	let dateCreated: Date
	var answers: [Answer]

	init(id: String = UUID().uuidString, name: String, dateCreated: Date = Date(), answers: [Answer] = []) {
		self.id = id
		self.name = name
		self.dateCreated = dateCreated
		self.answers = answers
	}
}

extension AnswerSet {

	init(_ presentableAnswerSet: PresentableAnswerSet) {
		let answers = presentableAnswerSet.answers.map { Answer($0) }
		self.init(id: presentableAnswerSet.id, name: presentableAnswerSet.name, answers: answers)
	}

	init(_ managedAnswerSet: ManagedAnswerSet) {
		let answersArray: [ManagedAnswer] = managedAnswerSet.answers.compactMap { $0 as? ManagedAnswer }
		self.init(
			id: managedAnswerSet.id,
			name: managedAnswerSet.name,
			dateCreated: managedAnswerSet.dateCreated,
			answers: answersArray.map { Answer($0) }
		)
	}
}
