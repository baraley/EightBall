//
//  PresentableHistoryAnswer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct PresentableHistoryAnswer: Equatable {

	let text: String
	let dateText: String

}

extension PresentableHistoryAnswer {

	init(_ historyAnswer: HistoryAnswer) {
		let formatter = DateFormatter.presentableHistoryAnswerFormatter

		text = historyAnswer.text
		dateText = formatter.string(from: historyAnswer.dateCreated)
	}
}
