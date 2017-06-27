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
    var persistenStoreCoordinator : NSPersistentStoreCoordinator? {
        get {
            if self.persistenStoreCoordinator != nil {
                return self.persistenStoreCoordinator
            }
            //store path
            let documentStorePath = self.applicationDocumentsDirectory().path?.appending("OurRecipes.sqlite")
            if(!FileManager.default.fileExists(atPath: documentStorePath!)) {
                let defaultStorePath = Bundle.main.path(forResource: "OurRecipes", ofType: "sqlite")
                if((defaultStorePath) != nil) {
                    do {
                        try FileManager.default.copyItem(atPath: defaultStorePath!, toPath: documentStorePath!)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
            self.persistenStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.managedObjectModel!)
            let defaultStoreURL:NSURL = NSURL .fileURL(withPath: documentStorePath!) as NSURL
            do {
                try self.persistenStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: defaultStoreURL as URL, options: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            let userStoreURL:NSURL = self.applicationDocumentsDirectory().appendingPathComponent("OurRecipes.sqlite")! as NSURL
            do {
                try self.persistenStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: userStoreURL as URL, options: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            return self.persistenStoreCoordinator            
        } set {
            
        }
    }
    private init(){
    
    }

    func applicationDocumentsDirectory()->NSURL {
        return (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)! as NSURL
    }
}
