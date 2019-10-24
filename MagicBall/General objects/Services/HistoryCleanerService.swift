//
//  HistoryCleanerService.swift
//  MagicBall
//
//  Created by Alexander Baraley on 21.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

final class HistoryCleanerService: HistoryCleanerServiceProtocol {

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func cleanHistory() {
		context.perform { [weak self] in
			let historyAnswers = (try? self?.context.fetch(ManagedHistoryAnswer.createRequest())) ?? []

			historyAnswers.forEach { self?.context.delete($0) }

			self?.context.saveIfNeeds()
		}
	}

}
