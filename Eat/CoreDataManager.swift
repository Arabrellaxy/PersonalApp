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
    var managedObjectModel : NSManagedObjectModel? {
        get{
            if self.managedObjectModel != nil {
              return  self.managedObjectModel
            }
            self.managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
            return self.managedObjectModel
        }
        set {
            
        }
    }
    private init(){
    
    }

    func applicationDocumentsDirectory()->NSURL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)! as NSURL
    }
}
