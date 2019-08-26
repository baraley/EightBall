//
//  AnswerSetsStore.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

class AnswerSetsStore {
	
	private(set) var answerSets: [AnswerSet] = [] {
		didSet {
			answerSetsDidChangeHandler?()
		}
	}
	
	init() {
		answerSets = loadAnswerSets()
	}
	
	var answerSetsDidChangeHandler: (() -> Void)?
	
	func save(_ answerSet: AnswerSet) {
		if let index = answerSets.firstIndex(of: answerSet) {
			answerSets[index] = answerSet
		} else {
			answerSets.append(answerSet)
		}
		
		saveAnswerSets()
	}
	
	func deleteAnswerSet(at index: Int) {
		guard index >= 0, index < answerSets.count else { return }
		
		answerSets.remove(at: index)
		
		saveAnswerSets()
	}
	
	// MARK: - Private
	
	private let answerSetsFilePath: String = FileManager
		.pathForFileInDocumentDirectory(withName: "AnswerSets")
	
	private func loadAnswerSets() -> [AnswerSet] {
		if let answerSets = FileManager.default
			.loadSavedContent(atPath: answerSetsFilePath) as [AnswerSet]? {
			
			return answerSets
		} else {
			let name = DefaultResouceName.rudeAnswers.rawValue
			let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]
			return [AnswerSet(name: "Rude", answers: rudeAnswers)]
		}
	}
	
	private func saveAnswerSets() {
		FileManager.default.saveContent(answerSets, atPath: answerSetsFilePath)
	}
}
