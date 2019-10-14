//
//  NSPersistentContainer+extensions.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

extension NSPersistentContainer {

	static func isPersistentStoreEmpty() -> Bool {
		let location = defaultDirectoryURL()
		let content = try? FileManager.default.contentsOfDirectory(at: location, includingPropertiesForKeys: nil)

		return content?.isEmpty == true
	}

}
