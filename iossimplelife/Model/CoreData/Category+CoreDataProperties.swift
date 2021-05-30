//
//  Category+CoreDataProperties.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/17.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageUrl: String?

}

extension Category : Identifiable {

}
