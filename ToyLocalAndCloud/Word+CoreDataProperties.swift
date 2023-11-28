//
//  Word+CoreDataProperties.swift
//  ToyLocalAndCloud
//
//  Created by m on 11/6/23.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var status: Int64 //cloud property
    @NSManaged public var word: String? //cloud property
    @NSManaged public var definition: String? //local
    @NSManaged public var sortNumber: Int64 //local

}

extension Word : Identifiable {

}
