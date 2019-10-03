//
//  AnswerSetsService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let defaultAnswerSetsFileName = "AnswerSets"

final class AnswerSetsService: AnswerSetsServiceProtocol {

	private let answerSetsFilePath: String

	init(answerSetsFileName: String = defaultAnswerSetsFileName) {
		self.answerSetsFilePath = FileManager.pathForFileInDocumentDirectory(withName: answerSetsFileName)
	}

	func loadAnswerSets() -> [AnswerSet] {
		let managedAnswerSets: [ManagedAnswerSet]

		if let answerSets = FileManager.default.loadSavedContent(atPath: answerSetsFilePath) as [ManagedAnswerSet]? {
			managedAnswerSets = answerSets
		} else {
			let name = DefaultResourceName.rudeAnswers.rawValue
			let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]

			managedAnswerSets = [ManagedAnswerSet(name: name, answers: rudeAnswers)]
		}

		return managedAnswerSets.map { $0.toAnswerSet()}
	}

	func save(_ answerSets: [AnswerSet]) {
		let managedAnswerSets = answerSets.map { ManagedAnswerSet(from: $0)}
		FileManager.default.saveContent(managedAnswerSets, atPath: answerSetsFilePath)
	}

}
