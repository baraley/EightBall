//
//  CoreDataContainer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

private let modelFileName = "MagicBallModel"

final class CoreDataContainer {

	private lazy var persistentContainer: NSPersistentContainer = NSPersistentContainer(name: modelFileName)

	func newBackgroundContext() -> NSManagedObjectContext {
		return persistentContainer.newBackgroundContext()
	}

	var isPersistentStoreEmpty: Bool {
		let location = NSPersistentContainer.defaultDirectoryURL()
		let content = try? FileManager.default.contentsOfDirectory(at: location, includingPropertiesForKeys: nil)

		return content?.isEmpty == true
	}

	func loadPersistentStores(with completionHandler: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { (_, error) in
			if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
			}
			completionHandler?()
		}
	}

	func restoreData() {
		let context = persistentContainer.newBackgroundContext()

		let wasMigrated = MigratorFromDataFilesToCoreData.restoreAnswersSetsIfAvailableIn(context)

		if !wasMigrated {
			DefaultDataProvider.createDefaultAnswerSetIn(context)
		}
	}

}
