
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
        if let firstPath = Bundle.main.path(forResource: entityName, ofType: resourceType) {
            //If your plist contain root as Array
            if let array = NSArray(contentsOfFile: firstPath){
                let  indexArray = array.enumerated().filter({ $0.element is Bool }).map({ $0.offset })
                let startLoc = indexArray.count > 0 ?  indexArray.last! + 1 : 0
                let endLoc = indexArray.count > 0 ?  array.count-indexArray.last!-1 : array.count

                let tempArray = array.subarray(with: NSMakeRange(startLoc, endLoc))
                let serialQueue = DispatchQueue(label: "importData")
                serialQueue.async {
                    _ = CoreDataManager.shareInstance.insertFoods(foodsArray: tempArray as NSArray)
                    }
            }
        }
        
    }
}
