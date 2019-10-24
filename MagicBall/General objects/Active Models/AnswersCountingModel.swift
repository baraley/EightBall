//
//  AnswersCountingModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 08.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let loadedAnswersNumberKey = "requestedAnswersNumberKey"

class AnswersCountingModel {

	private let secureStorage: SecureStorage

	init (secureStorage: SecureStorage) {
		self.secureStorage = secureStorage

		answersNumber = secureStorage.value(forKey: loadedAnswersNumberKey) ?? 0
	}

	var answersNumberChangesHandler: ((Int) -> Void)?

	private(set) var answersNumber: Int {
		didSet {
			secureStorage.setValue(answersNumber, forKey: loadedAnswersNumberKey)
			answersNumberChangesHandler?(answersNumber)
		}
	}

	func increase() {
		answersNumber += 1
	}

	func reset() {
		answersNumber = 0
	}
}
