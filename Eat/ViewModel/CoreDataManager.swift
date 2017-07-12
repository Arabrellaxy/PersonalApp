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
        var persistenStoreCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.managedObjectModel)
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
    
    func findAllEntitiesByName(entityName:String,pridicate:NSPredicate?) -> NSArray {
        var results : NSArray
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        if pridicate != nil {
            fetchRequest.predicate = pridicate
        }
        do {
            results = try managedObjectContext.fetch(fetchRequest) as NSArray
        } catch {
            fatalError("Failed to fetch entity: \(error)")
        }
        return results
    }
    
    
    func chooseFoodByPredicate(pridicate:NSPredicate?) -> Foods {
        let foods:NSArray = self.findAllEntitiesByName(entityName: "Foods", pridicate: pridicate)
        let x = UInt32(foods.count)
        
        let r = Int(arc4random_uniform(x))
        return foods[r] as! Foods
    }
    
}
