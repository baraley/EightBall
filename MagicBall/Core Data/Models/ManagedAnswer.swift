//
//  ManagedAnswer+CoreDataClass.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedAnswer)
public class ManagedAnswer: NSManagedObject {

}

extension ManagedAnswer {

    @nonobjc public class func makeRequest() -> NSFetchRequest<ManagedAnswer> {
        return NSFetchRequest<ManagedAnswer>(entityName: String(describing: ManagedAnswer.self))
    }

    @NSManaged public var text: String
    @NSManaged public var answerSet: ManagedAnswerSet

}
