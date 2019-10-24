//
//  PresentableAnswer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct PresentableAnswer: Equatable {

	let text: String

	init(text: String) {
		self.text = text.uppercased()
	}

}

extension PresentableAnswer {

	init(_ answer: Answer) {
		self.init(text: answer.text)
	}

}
