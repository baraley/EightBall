//
//  AnswerSet.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct AnswerSet: Codable, Equatable {
	let id: UUID = .init()
	let dateCreated: Date = .init()
	var name: String
	var answers: [String]
}

func == (lhs: AnswerSet, rhs: AnswerSet) -> Bool {
	return	lhs.id == rhs.id
}
