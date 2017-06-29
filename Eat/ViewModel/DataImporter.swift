//
//  DataImporter.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/29.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation

class DataImporter {
    func importDataByLocalResourceName(resourceName:String) -> Void {
        let fullResourceName : NSString = resourceName as NSString
        let resourceType : String = fullResourceName.pathExtension
        let entityName : String = fullResourceName.deletingPathExtension

        let total : NSInteger = CoreDataManager.shareInstance.findAllEntitiesByName(entityName: entityName).count
        var localCount : NSInteger = 0;
        if let path = Bundle.main.path(forResource: entityName, ofType: resourceType) {
            
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path){
                for tempArray in array {
                    localCount += ((tempArray as? NSArray)?.count)!
                }
                if localCount != total {
                    let lastArray:NSArray = array.object(at: array.count-1) as! NSArray
                    for tempDictionary in lastArray  {
                        if let tempDictionary = tempDictionary as? Dictionary<String, AnyObject> {
                            let food:Foods = CoreDataManager.shareInstance.insertNewEntity(entityName: entityName) as! Foods
                            for (key,value) in tempDictionary {
                                food.setValue(value, forKey: key)
                            }
                        }
                    }
                    if CoreDataManager.shareInstance.save() {
                       print("import successfully")
                    } else {
                        print("wrong")
                    }
                }
            }
            
        }

    }
}
