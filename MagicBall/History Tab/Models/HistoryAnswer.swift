//
//  HistoryAnswer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct HistoryAnswer: Equatable, Identifiable {

	let id: String
	let text: String
	let dateCreated: Date

	init(id: String = UUID().uuidString, text: String, dateCreated: Date = Date()) {
		self.id = id
		self.text = text
		self.dateCreated = dateCreated
	}

}

extension HistoryAnswer {

	init(_ managedHistoryAnswer: ManagedHistoryAnswer) {
		self.init(
			id: managedHistoryAnswer.id,
			text: managedHistoryAnswer.text,
			dateCreated: managedHistoryAnswer.dateCreated
		)
	}

}
