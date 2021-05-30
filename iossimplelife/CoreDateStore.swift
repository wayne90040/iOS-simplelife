//
//  CoreDateStore.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/19.
//

import Foundation
import CoreData
import os

class CoreDataStore {
    
    var persistentContainer: NSPersistentCloudKitContainer
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    init(container: NSPersistentCloudKitContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        let persistentContainer = { () -> NSPersistentCloudKitContainer in
            let container = NSPersistentCloudKitContainer(name: "iossimplelife")
            container.loadPersistentStores(completionHandler: {(result, error) in
                if let error = error as NSError? {
                    fatalError("Error\(error)")
                }
            })
            return container
        }()
        self.init(container: persistentContainer)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveBackgroundContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Category Core Data
extension CoreDataStore {
    // C
    func insertCategory(name: String, imageString: CategoryIcons, completion: (@escaping(Bool) -> Void) = {_ in }) {
        let newItem: Category = Category(context: context)
        newItem.name = name
        newItem.imageUrl = imageString.rawValue
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("insertCategory: \(error)")
            completion(false)
        }
    }
    
    // R
    func fetchAllCategories() -> [Category] {
        var result = [Category]()
        do {
            result = try context.fetch(Category.fetchRequest())
        } catch {
            print("fetchAllCategories: \(error)")
        }
        
        return result
    }
    
    // U
    func updateCategory(category: Category, name: String, imageString: String, completion: @escaping(Bool) -> Void) {
        category.name = name
        category.imageUrl = imageString
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("updateCategory: \(error)")
            completion(false)
        }
    }
    
    // D
    func deleteCategory(category: Category, completion: @escaping(Bool) -> Void) {
        context.delete(category)
        do {
            try context.save()
            completion(true)
        } catch {
            print("updateCategory: \(error)")
            completion(false)
        }
    }
}

// MARK: - Record Core Data
extension CoreDataStore {
    // C
    func insertRecord(category: String, imageUrl: String, price: String, note: String, date: Date, completion: @escaping(Bool) -> Void) {
        let newItem = Record(context: context)
        newItem.category = category
        newItem.price = price
        newItem.note = note
        newItem.date = date
        newItem.imageUrl = imageUrl
        
        do {
            try context.save()
            completion(true)
        }
        catch {
            // Error
            print("insertRecord: \(error)")
            completion(false)
        }
    }
    
    // R
    func fetchAllRecords() -> [Record] {
        var results: [Record] = [Record]()
        do {
            results = try context.fetch(Record.fetchRequest())
        }
        catch {
            print("fetchAllRecords: \(error)")
        }
        return results
    }
    
    // U
    func updateRecord(record: Record, category: String, price: String, note: String, completion: @escaping(Bool) -> Void) {
        record.category = category
        record.price = price
        record.note = note
        do {
            try context.save()
            completion(true)
        }
        catch {
            print("updateRecord: \(error)")
            completion(false)
        }
    }
    
    // D
    func deleteRecord(record: Record, completion: @escaping(Bool) -> Void) {
        context.delete(record)
        do {
            try context.save()
            completion(true)
        }
        catch {
            print("deleteRecord: \(error)")
            completion(false)
        }
    }
}
