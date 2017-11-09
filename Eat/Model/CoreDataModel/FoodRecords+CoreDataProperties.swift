//
//  FoodRecords+CoreDataProperties.swift
//  
//
//  Created by 谢艳 on 2017/11/2.
//
//

import Foundation
import CoreData


extension FoodRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodRecords> {
        return NSFetchRequest<FoodRecords>(entityName: "FoodRecords")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var mealType: Int32
    @NSManaged public var food: Foods?

}
