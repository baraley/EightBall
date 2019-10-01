//
//  AnswerSetsService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class AnswerSetsService: AnswerSetsServiceProtocol {

	private let answerSetsFilePath: String

	init(answerSetsFileName: String = "AnswerSets") {
		self.answerSetsFilePath = FileManager.pathForFileInDocumentDirectory(withName: answerSetsFileName)
	}

	func loadAnswerSets() -> [ManagedAnswerSet] {
		if let answerSets = FileManager.default.loadSavedContent(atPath: answerSetsFilePath) as [ManagedAnswerSet]? {

			return answerSets
		} else {
			let name = DefaultResourceName.rudeAnswers.rawValue
			let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]

			return [ManagedAnswerSet(name: "Rude", answers: rudeAnswers)]
		}
	}

	func save(_ answerSets: [AnswerSet]) {
		let managedAnswerSets = answerSets.map { ManagedAnswerSet(from: $0)}
		FileManager.default.saveContent(managedAnswerSets, atPath: answerSetsFilePath)
	}

}
