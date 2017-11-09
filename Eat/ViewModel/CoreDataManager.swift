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
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func insertFoods(foodsArray:NSArray) -> Bool {
        var success = true
        let semaphore = DispatchSemaphore(value: 0)
        persistentContainer.performBackgroundTask({ (backgroundContext) in
            for tempDictionary in foodsArray  {
                if let tempDictionary = tempDictionary as? Dictionary<String, AnyObject> {
                    let food:Foods = Foods(context:backgroundContext)
                    food.foodID = NSUUID.init().uuidString
                    for (key,value) in tempDictionary {
                        food.setValue(value, forKey: key)
                    }
                }
            }
            do {
                try backgroundContext.save()
                semaphore.signal()
            } catch {
                // handle error
                success = false
                semaphore.signal()
            }
        })
        semaphore.wait()
        return success
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
            let fetchRequest:NSFetchRequest<Foods> = Foods.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let x = UInt32(results.count)

                let r = Int(arc4random_uniform(x))
                if r <= results.count && results.count > 0 {
                    sleep(1)
                    completion(results[r])
                } else {
                    completion(nil)
                }
            } catch {
                fatalError("Failed to fetch foods: \(error)")
            }
        }
    }
    
    func saveFoodEntityPropertyValue(uniqueId:String, propertyName:String,newValue:Any)->Void {
        persistentContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest:NSFetchRequest<Foods> = Foods.fetchRequest()
            let predicate:NSPredicate = NSPredicate(format: "%K = %@", "foodID", uniqueId)
            fetchRequest.predicate = predicate
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let food = results[0] as Foods
                food.setValue(newValue, forKey: propertyName)
                try backgroundContext.save()
            } catch {
                fatalError("Failed to save foods: \(error)")
            }        
        }
    }

    func saveFoodForRecords(food:Foods,mealsType:Int32) -> Void {
        self.saveFoodsRecord(food: food, mealsType: mealsType, date: Date())
    }
    
    func saveFoodsRecord(food:Foods,mealsType:Int32,date:Date) -> Void {
        persistentContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest:NSFetchRequest<FoodRecords> = FoodRecords.fetchRequest()
            let (dateFrom,dateEnd) = ProjectHelper.shareInstance.startAndEndOfDate(date: date)
            
            // Set predicate as date
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@) AND mealType = %d", dateFrom as CVarArg, dateEnd as CVarArg,mealsType)
            fetchRequest.predicate = datePredicate
            
            //food
            let foodFetchRequest:NSFetchRequest<Foods> = Foods.fetchRequest()
            let predicate:NSPredicate = NSPredicate(format: "%K = %@", "foodID", food.foodID)
            foodFetchRequest.predicate = predicate
            var tempFood :Foods?
            do {
                let results = try backgroundContext.fetch(foodFetchRequest)
                tempFood = results[0] as Foods
            } catch {
                fatalError("Failed to fetch foods: \(error)")
            }
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if results.count > 0 {
                    let record = results[0] as FoodRecords
                    record.food = tempFood
                } else {
                    let record:FoodRecords = FoodRecords(context:backgroundContext)
                    record.date = NSDate()
                    record.mealType = mealsType
                    record.food = tempFood
                }
                try backgroundContext.save()
            } catch {
                // handle error
                fatalError("Failed to save record: \(error)")
            }
        }
    }
    
    func foodRecordsOfDay(date:Date,completion: @escaping (_ record: [FoodRecords]?) -> Void) {
            let fetchRequest:NSFetchRequest<FoodRecords> = FoodRecords.fetchRequest()
            let (dateFrom,dateEnd) = ProjectHelper.shareInstance.startAndEndOfDate(date: date)
            
            // Set predicate as date
            let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", dateFrom as CVarArg, dateEnd as CVarArg)
            fetchRequest.predicate = datePredicate
            do {
                let  results = try persistentContainer.viewContext.fetch(fetchRequest)
                completion(results)
            } catch {
                // handle error
                fatalError("Failed to save record: \(error)")
            }
    }
}
