
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
        
        let total : NSInteger = CoreDataManager.shareInstance.findAllEntitiesByName(entityName: entityName,pridicate: nil).count
        var localCount : NSInteger = 0;
        if let path = Bundle.main.path(forResource: entityName, ofType: resourceType) {
            
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path){
                for tempArray in array {
                    localCount += ((tempArray as? NSArray)?.count)!
                }
                if localCount != total {
                    if total == 0 {
                        CoreDataManager.shareInstance.insertFoods(foodsArray: array)
                    }
                }
            }
            
        }
        
    }
}
