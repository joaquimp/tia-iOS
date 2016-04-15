//
//  CoreDataHelper.swift
//  MackTIA
//
//  Created by joaquim on 04/09/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import CoreData

/** CoreDataHelper Class

*/
class CoreDataHelper {
    
    class var sharedInstance : CoreDataHelper {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CoreDataHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CoreDataHelper()
        }
        return Static.instance!
    }
    private init(){
        
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "MackMobile.CoreData_Swift" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MackTIA", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MackTIA.sqlite")
        print(url)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "CoreDataInicialization", code: 0001, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            // A aplicacao sera finalizada por nao ser possivel usar o CoreData
            // eh recomendado tratar este erro, exibindo uma orientacao ao usuario para solucao do problema
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    // A aplicacao sera finalizada por nao ser possivel usar o CoreData
                    // eh recomendado tratar este erro, exibindo uma orientacao ao usuario para solucao do problema
                    abort()
                }
            }
        }
    }
    
    // MARK: - Util
    func removeAll(entityName:String){
        let fetchRequest = NSFetchRequest(entityName: entityName)

        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do{
                try persistentStoreCoordinator!.executeRequest(deleteRequest, withContext: managedObjectContext!)
            }catch{
                print("Error removing entity: \(entityName) - \(error)")
            }
        }else{
            do{
                let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                
                for i in 0 ..< fetchedResults!.count {
                    CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(fetchedResults![i])
                }
                CoreDataHelper.sharedInstance.saveContext()
            }catch{
                print("Error removing entity: \(entityName) - \(error)")
            }
        }
    }
}
