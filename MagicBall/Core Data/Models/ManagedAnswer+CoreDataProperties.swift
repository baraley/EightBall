//
//  ManagedAnswer+CoreDataProperties.swift
//  MagicBall
//
//  Created by Alexander Baraley on 12.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//
//

import Foundation
import CoreData

extension ManagedAnswer {

    @nonobjc public class func makeRequest() -> NSFetchRequest<ManagedAnswer> {
        return NSFetchRequest<ManagedAnswer>(entityName: "Answer")
    }

    @NSManaged public var text: String
    @NSManaged public var answerSet: ManagedAnswerSet

}
