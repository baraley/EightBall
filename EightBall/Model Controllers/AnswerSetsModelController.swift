//
//  AnswerSetsModelController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

class AnswerSetsModelController: NSObject {
	
	private(set) lazy var answerSets: [AnswerSet] = loadAnswerSets()
	
	func save(_ answerSet: AnswerSet) {
		if let index = answerSets.firstIndex(of: answerSet) {
			answerSets[index] = answerSet
		} else {
			answerSets.append(answerSet)
		}
		
		answerSets.sort { $0.dateCreated > $1.dateCreated }
		
		FileManager.default.saveContent(answerSets, atPath: answerSetsFilePath)
	}
	
	// MARK: - Private
	
	private let answerSetsFilePath: String = FileManager
		.pathForFileInDocumentDirectory(withName: "AnswerSets")
	
	private func loadAnswerSets() -> [AnswerSet] {
		if let answerSets = FileManager.default
			.loadSavedContent(atPath: answerSetsFilePath) as [AnswerSet]? {
			
			return answerSets
		} else {
			let name = DefaultResouce.rudeAnswers.rawValue
			let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]
			return [AnswerSet(name: "Rude", answers: rudeAnswers)]
		}
	}
}
