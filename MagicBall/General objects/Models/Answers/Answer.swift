//
//  Answer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 02.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct Answer: Codable {

	let text: String
}

extension Answer {

	init(_ presentableAnswer: PresentableAnswer) {
		self = .init(text: presentableAnswer.text)
	}

	init(_ managedAnswer: ManagedAnswer) {
		self = .init(text: managedAnswer.text)
	}
}
