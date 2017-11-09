//
//  XYDayNode.swift
//  Eat
//
//  Created by 谢艳 on 2017/11/2.
//  Copyright © 2017年 谢艳. All rights reserved.
//

import UIKit

class XYDayNode: NSObject {
    public private(set) var year: NSInteger = 0
    public private(set) var month: NSInteger = 0
    public private(set) var day: NSInteger = 0
    public private(set) var weekDay: NSInteger = 0
    public var date: Date?{
        get{
            return  ProjectHelper.shareInstance.date(year: self.year, month: self.month, day: self.day)
        }
    }

    init(year:NSInteger, month:NSInteger, day:NSInteger,weekDay:NSInteger) {
        self.year = year
        self.month = month
        self.day = day
        self.weekDay = weekDay
    }
    func isBefore(day:XYDayNode) -> Bool {
        if day.year != self.year {
            return self.year < day.year
        }
        if day.month != self.month {
            return self.month < day.month
        }
        return self.day < day.day
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is XYDayNode{
            let day : XYDayNode = object as! XYDayNode
            return day.year == self.year && day.month == self.month && day.day == self.day
        }
        return false
    }
}
