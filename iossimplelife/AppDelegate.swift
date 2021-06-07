//
//  AppDelegate.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.isFirstLaunch() {
            setDefaultCateInCoreData()
        }
        
        return true
    }
    
    private func setDefaultCateInCoreData() {
        CoreDataStore().insertCategory(name: "早餐", imageString: .breakfast, isCost: true)
        CoreDataStore().insertCategory(name: "午餐", imageString: .lunch, isCost: true)
        CoreDataStore().insertCategory(name: "點心", imageString: .snack, isCost: true)
        CoreDataStore().insertCategory(name: "晚餐", imageString: .dinner, isCost: true)
        CoreDataStore().insertCategory(name: "禮物", imageString: .gift, isCost: true)
        CoreDataStore().insertCategory(name: "飲料", imageString: .drink, isCost: true)
        CoreDataStore().insertCategory(name: "娛樂", imageString: .game, isCost: true)
        CoreDataStore().insertCategory(name: "購物", imageString: .shopping, isCost: true)
        CoreDataStore().insertCategory(name: "日用品", imageString: .lifeshopping, isCost: true)
        CoreDataStore().insertCategory(name: "醫療", imageString: .hospital, isCost: true)
        CoreDataStore().insertCategory(name: "社交", imageString: .social, isCost: true)
        CoreDataStore().insertCategory(name: "房租", imageString: .house, isCost: true)
        CoreDataStore().insertCategory(name: "交通", imageString: .transport, isCost: true)
        CoreDataStore().insertCategory(name: "投資", imageString: .investment, isCost: true)
        CoreDataStore().insertCategory(name: "其他", imageString: .other, isCost: true)
        
        CoreDataStore().insertCategory(name: "薪水", imageString: .salary, isCost: false)
        CoreDataStore().insertCategory(name: "獎金", imageString: .bonus, isCost: false)
        CoreDataStore().insertCategory(name: "投資", imageString: .investment_, isCost: false)
        CoreDataStore().insertCategory(name: "其他", imageString: .other, isCost: false)
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "iossimplelife")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

