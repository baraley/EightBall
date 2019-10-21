//
//  NSManagedObjectContext+Extension.swift
//  MagicBall
//
//  Created by Alexander Baraley on 13.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {

	func saveIfNeeds() {
		do {
			if hasChanges {
				try save()
			}
		} catch let error as NSError {
			fatalError("Unable to save context. Error: \(error), \(error.userInfo)")
		}
	}
}
