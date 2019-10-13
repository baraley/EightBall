//
//  PersistentContainer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

private let modelFileName = "MagicBallModel"
private let fileExtension = "xcdatamodeld"

final class PersistentContainer: NSPersistentContainer {

	convenience init() {
		self.init(name: modelFileName)
		loadPersistentStores { (_, error) in
			if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
		}
	}

}

//extension PersistentContainer {
//
//	static func isPersistenceStoreEmpty() -> Bool {
//		let location = defaultDirectoryURL()
//		let content = try? FileManager.default.contentsOfDirectory(at: location, includingPropertiesForKeys: nil)
//
//		return content?.isEmpty == true
//	}
//
//}
