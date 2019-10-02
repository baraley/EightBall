//
//  Answer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct Answer {

	let text: String

}

extension Answer {

	init(from presentableAnswer: PresentableAnswer) {
		self = .init(text: presentableAnswer.text)
	}

	func toPresentableAnswer() -> PresentableAnswer {
		return PresentableAnswer(text: text)
	}
}
