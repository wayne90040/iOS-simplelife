//
//  Record+CoreDataProperties.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/23.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        return NSFetchRequest<Record>(entityName: "Record")
    }

    @NSManaged public var category: String?
    @NSManaged public var note: String?
    @NSManaged public var price: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var date: String?
    @NSManaged public var isCost: Bool

}

extension Record : Identifiable {

}
