//
//  Persistence.swift
//  ToyLocalAndCloud
//
//  Created by m on 11/1/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Word(context: viewContext)
            newItem.definition = "Definiton for word \(i)"
            newItem.sortNumber = Int64(i)
            newItem.word = "Word \(i)"
            newItem.status = 1
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "ToyLocalAndCloud")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        let cloudURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                      .appendingPathComponent("cloud.sqlite")
        let localURL = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).first!
                      .appendingPathComponent("local.sqlite")
        let cloudDesc = NSPersistentStoreDescription(url: cloudURL)
        cloudDesc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.toy.com")
//        cloudDesc.configuration = "ToyLocalAndCloud"
        let localDesc = NSPersistentStoreDescription(url: localURL)
//        localDesc.configuration = "local"
        container.persistentStoreDescriptions = [cloudDesc,localDesc]
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
        container.viewContext.automaticallyMergesChangesFromParent = true
        /*
         if store is empty then load some test data. this loads it to the cloud
         */
        
    }
}
