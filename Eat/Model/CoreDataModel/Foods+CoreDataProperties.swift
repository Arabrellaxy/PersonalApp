//
//  Foods+CoreDataProperties.swift
//  Eat
//
//  Created by 谢艳 on 2017/6/28.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import Foundation
import CoreData


extension Foods {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Foods> {
        return NSFetchRequest<Foods>(entityName: "Foods")
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        foodID = UUID.init().uuidString
    }
    
    @NSManaged public var mealsType: Int32
    @NSManaged public var name: String
    @NSManaged public var foodID: String
    @NSManaged public var minPrice: Double
    @NSManaged public var maxPrice: Double
    @NSManaged public var selfMade: Bool
    @NSManaged public var taste: Int32
}
