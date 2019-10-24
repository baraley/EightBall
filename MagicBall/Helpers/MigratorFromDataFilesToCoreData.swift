//
//  MigratorFromDataFilesToCoreData.swift
//  MagicBall
//
//  Created by Alexander Baraley on 14.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

private let answerSetsFilePath = FileManager.pathForFileInDocumentDirectory(withName: "AnswerSets")

struct MigratorFromDataFilesToCoreData {

	static func restoreAnswersSetsIfAvailableIn(_ context: NSManagedObjectContext) -> Bool {
		guard let migratedAnswerSets = FileManager.default
			.loadSavedContent(atPath: answerSetsFilePath) as [OldManagedAnswerSet]?
		else {
			return false
		}

		context.perform {
			migratedAnswerSets.forEach {
				let managedAnswerSet = ManagedAnswerSet(context: context)
				let answerSet = $0.toAnswerSet()
				managedAnswerSet.populateWith(answerSet)
			}
			context.saveIfNeeds()
		}
		try? FileManager.default.removeItem(atPath: answerSetsFilePath)

		return true
	}

	private struct OldManagedAnswerSet: Codable, Equatable {

		static func == (lhs: OldManagedAnswerSet, rhs: OldManagedAnswerSet) -> Bool {
			return	lhs.id == rhs.id
		}

		let id: UUID
		var name: String
		var answers: [String]

		func toAnswerSet() -> AnswerSet {
			return AnswerSet(id: id.uuidString, name: name, answers: answers.map { Answer(text: $0) })
		}
	}
}
