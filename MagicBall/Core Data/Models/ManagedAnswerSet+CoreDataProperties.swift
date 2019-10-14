//
//  ManagedAnswerSet+CoreDataProperties.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

extension ManagedAnswerSet {

    @nonobjc public class func makeRequest() -> NSFetchRequest<ManagedAnswerSet> {
        return NSFetchRequest<ManagedAnswerSet>(entityName: "AnswerSet")
    }

	@NSManaged public var dateCreated: Date
	@NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var answers: NSOrderedSet

}

// MARK: Generated accessors for answers
extension ManagedAnswerSet {

    @objc(insertObject:inAnswersAtIndex:)
    @NSManaged public func insertIntoAnswers(_ value: ManagedAnswer, at idx: Int)

    @objc(removeObjectFromAnswersAtIndex:)
    @NSManaged public func removeFromAnswers(at idx: Int)

    @objc(insertAnswers:atIndexes:)
    @NSManaged public func insertIntoAnswers(_ values: [ManagedAnswer], at indexes: NSIndexSet)

    @objc(removeAnswersAtIndexes:)
    @NSManaged public func removeFromAnswers(at indexes: NSIndexSet)

    @objc(replaceObjectInAnswersAtIndex:withObject:)
    @NSManaged public func replaceAnswers(at idx: Int, with value: ManagedAnswer)

    @objc(replaceAnswersAtIndexes:withAnswers:)
    @NSManaged public func replaceAnswers(at indexes: NSIndexSet, with values: [ManagedAnswer])

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: ManagedAnswer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: ManagedAnswer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSOrderedSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSOrderedSet)

}
