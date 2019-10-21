//
//  CoreDataContainer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

private let modelFileName = "MagicBallModel"

final class CoreDataContainer: NSPersistentContainer {

	init(name: String = modelFileName) {
		guard let model = NSManagedObjectModel.mergedModel(from: nil) else {
			fatalError("Can't load managed object models from bundle")
		}
		super.init(name: name, managedObjectModel: model)
	}

	var isPersistentStoreEmpty: Bool {
		let location = NSPersistentContainer.defaultDirectoryURL()
		let content = try? FileManager.default.contentsOfDirectory(at: location, includingPropertiesForKeys: nil)

		return content?.isEmpty == true
	}

	func loadPersistentStores(with completionHandler: (() -> Void)? = nil) {
		loadPersistentStores { (_, error) in
			if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
			}
			completionHandler?()
		}
	}

	func restoreData() {
		performBackgroundTask { (context) in
			let wasMigrated = MigratorFromDataFilesToCoreData.restoreAnswersSetsIfAvailableIn(context)

			if !wasMigrated {
				DefaultDataProvider.createDefaultAnswerSetIn(context)
			}
		}
	}

}
