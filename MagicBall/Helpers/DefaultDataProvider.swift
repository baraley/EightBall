//
//  DefaultDataProvider.swift
//  MagicBall
//
//  Created by Alexander Baraley on 14.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

struct DefaultDataProvider {

	static func createDefaultAnswerSetIn(_ context: NSManagedObjectContext) {
		let name = DefaultResourceName.rudeAnswers.rawValue
		let rudeAnswers = FileManager.default.loadContentFromBundle(withName: name) as [String]
		let answerSet = AnswerSet(name: name, answers: rudeAnswers.map { Answer(text: $0) })

		let rudeAnswerSet = ManagedAnswerSet(context: context)
		rudeAnswerSet.populateWith(answerSet)

		context.saveIfNeeds()
	}
}
