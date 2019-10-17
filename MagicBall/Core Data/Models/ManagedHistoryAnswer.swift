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
public class ManagedHistoryAnswer: NSManagedObject {

	public override func awakeFromInsert() {
		super.awakeFromInsert()

		id = UUID().uuidString
		dateCreated = Date()
	}

}

extension ManagedHistoryAnswer {

	func toHistoryAnswer() -> HistoryAnswer {
		return HistoryAnswer(id: id, text: text, dateCreated: dateCreated)
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
