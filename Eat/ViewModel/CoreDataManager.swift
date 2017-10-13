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
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Eat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func insertFoods(foodsArray:NSArray) -> Void {
        persistentContainer.performBackgroundTask({ (backgroundContext) in
            for foodArray:NSArray in (foodsArray as! [NSArray]) {
                for tempDictionary in foodArray  {
                    if let tempDictionary = tempDictionary as? Dictionary<String, AnyObject> {
                        let food:Foods = Foods(context:backgroundContext)
                        for (key,value) in tempDictionary {
                            food.setValue(value, forKey: key)
                        }
                    }
                }
            }
            do {
                try backgroundContext.save()
            } catch {
                // handle error
                print("error", error)
            }
        })
    }
    
    func findAllEntitiesByName(entityName:String,pridicate:NSPredicate?) -> NSArray {
        var results : NSArray
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        if pridicate != nil {
            fetchRequest.predicate = pridicate
        }
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest) as NSArray
        } catch {
            fatalError("Failed to fetch entity: \(error)")
        }
        return results
    }
    
    func chooseFoodByPredicate(predicate:NSPredicate?, completion: @escaping (_ food: Foods?) -> Void) {
        persistentContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Foods")
            fetchRequest.predicate = predicate
            do {
                let results = try backgroundContext.fetch(fetchRequest) as! [Foods]
                let x = UInt32(results.count)
                
                let r = Int(arc4random_uniform(x))
                if r <= results.count && results.count > 0 {
                    completion(results[r])
                } else {
                    completion(nil)
                }
            } catch {
                fatalError("Failed to fetch foods: \(error)")
            }
        }
    }
    
}
