//
//  ConfiguredFetchRequest.swift
//  MagicBall
//
//  Created by Alexander Baraley on 18.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

enum ConfiguredFetchRequest {

	static var answerSetsRequest: NSFetchRequest<ManagedAnswerSet> {
		let request = ManagedAnswerSet.createRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(ManagedAnswerSet.dateCreated), ascending: true)
		]

		return request
	}

	static var notEmptyAnswerSetsRequest: NSFetchRequest<ManagedAnswerSet> {
		let request = answerSetsRequest
		request.predicate = NSPredicate(format: "\(#keyPath(ManagedAnswerSet.answers)).@count > 0")

		return request
	}

	static var managedHistoryAnswersRequest: NSFetchRequest<ManagedHistoryAnswer> {
		let fetchRequest = ManagedHistoryAnswer.createRequest()
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: #keyPath(ManagedHistoryAnswer.dateCreated), ascending: false)
		]

		return fetchRequest
	}
}
