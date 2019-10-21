//
//  ManagedHistoryAnswer+CoreDataClass.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedHistoryAnswer)
public class ManagedHistoryAnswer: NSManagedObject, Populatable, Identifiable {

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		id = UUID().uuidString
		dateCreated = Date()
	}

	func populateWith(_ historyAnswer: HistoryAnswer) {
		text = historyAnswer.text
	}

}

extension ManagedHistoryAnswer {

    @nonobjc public class func makeRequest() -> NSFetchRequest<ManagedHistoryAnswer> {
		return NSFetchRequest<ManagedHistoryAnswer>(entityName: String(describing: ManagedHistoryAnswer.self))
    }

    @NSManaged public var text: String
    @NSManaged private(set) var dateCreated: Date
    @NSManaged private(set) var id: String

}
