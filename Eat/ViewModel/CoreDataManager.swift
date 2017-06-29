//
//  CoreDataManager.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/27.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shareInstance = CoreDataManager()
    
     fileprivate lazy var managedObjectModel : NSManagedObjectModel = {
        var managedObjectModel : NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        return managedObjectModel
    }()
    
    private lazy var persistenStoreCoordinator : NSPersistentStoreCoordinator = {
        //store path
//        let  documentStorePath: String? = self.applicationDocumentsDirectory().path?.appending(AppConfigConstants.storeName)
//        if(!FileManager.default.fileExists(atPath: documentStorePath!)) {
//            let defaultStorePath = Bundle.main.path(forResource: AppConfigConstants.storeName, ofType: "sqlite")
//            if((defaultStorePath) != nil) {
//                do {
//                    try FileManager.default.copyItem(atPath: defaultStorePath!, toPath: documentStorePath!)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
//        }
        var persistenStoreCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.managedObjectModel)
//        let defaultStoreURL:NSURL = NSURL .fileURL(withPath: documentStorePath!) as NSURL
//        do {
//            try persistenStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: defaultStoreURL as URL, options: nil)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        let userStoreURL:NSURL = self.applicationDocumentsDirectory().appendingPathComponent(AppConfigConstants.storeName)! as NSURL
        do {
            try persistenStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: userStoreURL as URL, options: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return persistenStoreCoordinator
        
    }()
    
    private lazy var managedObjectContext:NSManagedObjectContext = {
        var managedObjecContext:NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        let tempPersistentCoordinator:NSPersistentStoreCoordinator? = self.persistenStoreCoordinator
        if tempPersistentCoordinator != nil {
            managedObjecContext.persistentStoreCoordinator = tempPersistentCoordinator
        }
        return managedObjecContext
    }()
    
    private init(){
        
    }

    func applicationDocumentsDirectory()->NSURL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)! as NSURL
    }
    
    func insertNewEntity(entityName:String) -> NSManagedObject {
        let managedObjectContext = self.managedObjectContext
        let managedObject : NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
       
        return managedObject
    }
    
    func save() -> Bool {
        var result = true
        do {
            try managedObjectContext.save()
        } catch {
            result = false
            fatalError("Failure to save context: \(error)")
        }
        return result
    }
    
    func findAllEntitiesByName(entityName:String) -> NSArray {
        var results : NSArray
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        do {
            results = try managedObjectContext.fetch(fetchRequest) as NSArray
        } catch {
            fatalError("Failed to fetch entity: \(error)")
        }
        return results
    }
    
//    func insertNewEntitiesFromArray(entities:NSArray) -> Bool {
//        var result = true
//        
//        return result
//
//    }
}
