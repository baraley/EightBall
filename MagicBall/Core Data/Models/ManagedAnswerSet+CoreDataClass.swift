//
//  ManagedAnswerSet+CoreDataClass.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedAnswerSet)
public class ManagedAnswerSet: NSManagedObject {

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		id = UUID().uuidString
		dateCreated = Date()
		answers = NSOrderedSet()
	}

}

extension ManagedAnswerSet {

	func toAnswerSet() -> AnswerSet {
		let answersArray: [ManagedAnswer] = answers.array.compactMap { $0 as? ManagedAnswer}
		return AnswerSet(id: id, name: name, answers: answersArray.map { Answer(text: $0.text) })
	}

	func populateWith(_ answerSet: AnswerSet) {
		guard let context = managedObjectContext else { return }

		name = answerSet.name
		id = answerSet.id

		removeFromAnswers(answers)

		for (index, answer) in answerSet.answers.enumerated() {
			let managedAnswer = ManagedAnswer(context: context)
			managedAnswer.text = answer.text
			managedAnswer.answerSet = self

			insertIntoAnswers(managedAnswer, at: index)
		}
	}

}
